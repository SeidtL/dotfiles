#!/usr/bin/env python3
"""
stowpy - An implementation of GNU Stow functionality utilizing vibe-coding.

SYNOPSIS:
    stow [OPTION ...] [-D|-S|-R] PACKAGE ... [-D|-S|-R] PACKAGE ...

OPTIONS:
    -d DIR, --dir=DIR     Set stow dir to DIR (default is current dir)
    -t DIR, --target=DIR  Set target to DIR (default is parent of stow dir)

    -S, --stow            Stow the package names that follow this option
    -D, --delete          Unstow the package names that follow this option
    -R, --restow          Restow (like unstow followed by stow)

    --ignore=REGEX        Ignore files ending in this regex
    --defer=REGEX         Don't stow files beginning with this regex if
                          the file is already stowed to another package
    --override=REGEX      Force stowing files beginning with this regex if
                          the file is already stowed to another package
    --adopt               Import existing files into stow package from target

    --simulate           Do not actually make any filesystem changes
    -v, --verbose[=N]     Increase verbosity (levels 0-5)
    -V, --version         Show version number
    -h, --help            Show this help
"""

import argparse
import re
from pathlib import Path
import sys
from typing import Iterator, Optional, Tuple

__version__ = (0, 1, 0)


class Stow:
    """Main stow functionality class."""

    def __init__(
        self,
        stow_dir: Path,
        target_dir: Path,
        simulate: bool = False,
        verbose: int = 0,
        ignore: Optional[str] = None,
        defer: Optional[str] = None,
        override: Optional[str] = None,
        adopt: bool = False,
    ):
        """
        Initialize Stow instance.

        Args:
            stow_dir: Directory containing packages to stow
            target_dir: Directory where symlinks will be created
            simulate: If True, don't actually make filesystem changes
            verbose: Verbosity level (0-5)
            ignore: Regex pattern for files to ignore
            defer: Regex pattern for files to defer if already stowed elsewhere
            override: Regex pattern for files to override if already stowed elsewhere
            adopt: If True, import existing files from target

        Note:
            Packages starting with "dot-" are always treated as dotfiles,
            e.g., "dot-vim" becomes ".vim" in the target directory.
        """
        self.stow_dir = stow_dir.expanduser().resolve()
        self.target_dir = target_dir.expanduser().resolve()
        self.simulate = simulate
        self.verbose = verbose
        self.ignore_pattern = re.compile(ignore) if ignore else None
        self.defer_pattern = re.compile(defer) if defer else None
        self.override_pattern = re.compile(override) if override else None
        self.adopt = adopt

    def _log(self, level: int, message: str) -> None:
        """Log message if verbosity level is high enough."""
        if self.verbose >= level:
            print(message)

    def _format_path(self, path: Path) -> str:
        """Format path for display, replacing $HOME with ~."""
        try:
            home = Path.home()
            if path.is_absolute() and self._is_relative_to(path, home):
                return "~" / path.relative_to(home)
        except (ValueError, OSError):
            pass
        return str(path)

    def _get_package_path(self, package_name: str) -> Path:
        """Get the full path to a package (actual directory name)."""
        return self.stow_dir / package_name

    def _get_dot_target_name(self, package_name: str) -> str:
        """Get the target name for a package (transforming "dot-" to ".")."""
        if package_name.startswith("dot-"):
            return "." + package_name[4:]
        return package_name

    def _transform_dot_path(self, path: Path) -> Path:
        """Transform a path by converting "dot-" prefixes to "." prefixes."""
        parts = []
        for part in path.parts:
            if part.startswith("dot-"):
                parts.append("." + part[4:])
            else:
                parts.append(part)
        return Path(*parts)

    def _should_ignore(self, path: Path) -> bool:
        """Check if a path should be ignored."""
        # Ignore files/directories starting with dot
        if path.name.startswith("."):
            self._log(3, f"Ignoring dotfile: {self._format_path(path)}")
            return True
        if self.ignore_pattern:
            if self.ignore_pattern.search(path.name):
                self._log(3, f"Ignoring: {self._format_path(path)}")
                return True
        return False

    def _is_relative_to(self, path: Path, other: Path) -> bool:
        """Check if path is relative to other (Python 3.8 compatibility)."""
        try:
            path.relative_to(other)
            return True
        except ValueError:
            return False

    def _is_owned_by_package(self, target_link: Path, package_path: Path) -> bool:
        """Check if a symlink points to a file within the given package.

        Only resolves the first hop of the symlink, not the entire chain.
        This allows source files that are themselves symlinks to be properly
        recognized as owned by the package.
        """
        if not target_link.is_symlink():
            return False
        try:
            # Read the symlink target without resolving the entire chain
            link_target = target_link.readlink()

            # If relative, resolve it relative to the symlink's parent directory
            if not link_target.is_absolute():
                link_target = (target_link.parent / link_target).resolve()

            # Check if the (first hop) target is within the package
            return self._is_relative_to(link_target, package_path)
        except (OSError, ValueError):
            return False

    def _find_owning_package(self, target_link: Path) -> Optional[Path]:
        """Find which package owns a given symlink."""
        if not target_link.is_symlink():
            return None
        try:
            resolved = target_link.resolve()
            for item in self.stow_dir.iterdir():
                if not item.is_dir():
                    continue
                pkg_path = item
                if item.name.startswith("dot-"):
                    # For "dot-" packages, check against the transformed path
                    pkg_path = item.parent / ("." + item.name[4:])
                if self._is_relative_to(resolved, pkg_path):
                    return item
        except (OSError, ValueError):
            pass
        return None

    def _should_defer(self, target_link: Path) -> bool:
        """Check if we should defer stowing this file."""
        if not self.defer_pattern:
            return False

        if not target_link.exists() and not target_link.is_symlink():
            return False

        # Check if the file matches defer pattern
        if not self.defer_pattern.search(target_link.name):
            return False

        # Check if it's owned by another package
        owner = self._find_owning_package(target_link)
        if owner and not self._is_owned_by_package(target_link, self._get_package_path(owner.name)):
            self._log(2, f"Deferring: {self._format_path(target_link)} (owned by {owner.name})")
            return True

        return False

    def _should_override(self, target_link: Path) -> bool:
        """Check if we should override an existing file."""
        if not self.override_pattern:
            return False

        if not target_link.exists() and not target_link.is_symlink():
            return False

        if self.override_pattern.search(target_link.name):
            self._log(2, f"Overriding: {self._format_path(target_link)}")
            return True

        return False

    def iter_stow_pairs(self, package_name: str) -> Iterator[Tuple[Path, Path]]:
        """
        Generate (source_file, target_link) pairs for a package.

        Args:
            package_name: Name of the package to stow

        Yields:
            Tuple of (source_file, target_link) paths
        """
        # Use actual package directory for source
        package_path = self._get_package_path(package_name)

        if not package_path.exists():
            raise FileNotFoundError(f"Package does not exist: {package_path}")
        if not package_path.is_dir():
            raise NotADirectoryError(f"Package is not a directory: {package_path}")

        for source_file in package_path.rglob("*"):
            if not source_file.is_file() and not source_file.is_symlink():
                continue

            if self._should_ignore(source_file):
                continue

            # Calculate relative path from package to target
            rel_path = source_file.relative_to(package_path)

            # Transform "dot-" prefixes to "." in the path
            rel_path = self._transform_dot_path(rel_path)

            # For dotfiles packages ("dot-xxx"), use the transformed package name as a subdirectory
            # For regular packages, flatten one level (GNU Stow behavior)
            if package_name.startswith("dot-"):
                target_pkg_name = self._get_dot_target_name(package_name)
                target_link = self.target_dir / target_pkg_name / rel_path
            else:
                # Regular packages: flatten one level
                # stow/mypkg/.bashrc -> target/.bashrc
                target_link = self.target_dir / rel_path

            yield source_file, target_link

    def stow(self, package_name: str) -> None:
        """
        Stow a package by creating symlinks.

        Args:
            package_name: Name of the package to stow
        """
        package_path = self._get_package_path(package_name)

        for source_file, target_link in self.iter_stow_pairs(package_name):
            # Check if we should defer
            if self._should_defer(target_link):
                continue

            # Handle existing target
            adopted = False
            if target_link.exists() or target_link.is_symlink():
                if self._is_owned_by_package(target_link, package_path):
                    self._log(3, f"Already owned: {self._format_path(target_link)}")
                    continue

                # Adopt: handle existing target file
                if self.adopt and target_link.is_file() and not target_link.is_symlink():
                    if not source_file.exists():
                        # Package file doesn't exist: move target into package
                        self._log(1, f"Adopting: {self._format_path(target_link)} -> {self._format_path(source_file)}")
                        if not self.simulate:
                            source_file.parent.mkdir(parents=True, exist_ok=True)
                            target_link.replace(source_file)
                        adopted = True
                    else:
                        # Both exist: adopt means replace target with symlink
                        self._log(1, f"Adopting (replacing): {self._format_path(target_link)}")
                        if not self.simulate:
                            target_link.unlink()
                    # In both cases, continue to create symlink
                else:
                    # Not adopting or not adoptable
                    if not self._should_override(target_link):
                        raise FileExistsError(
                            f"Target already exists (not owned by this package): {self._format_path(target_link)}"
                        )

                    # Remove existing for override
                    self._log(2, f"Removing for override: {self._format_path(target_link)}")
                    if not self.simulate:
                        if target_link.is_dir() and not target_link.is_symlink():
                            target_link.rmdir()
                        else:
                            target_link.unlink()

            # Create symlink
            self._log(0, f"Stowing: {self._format_path(source_file)} -> {self._format_path(target_link)}")
            if not self.simulate:
                target_link.parent.mkdir(parents=True, exist_ok=True)
                target_link.symlink_to(source_file)

    def unstow(self, package_name: str) -> None:
        """
        Unstow a package by removing symlinks.

        Args:
            package_name: Name of the package to unstow
        """
        package_path = self._get_package_path(package_name)

        if not package_path.exists():
            raise FileNotFoundError(f"Package does not exist: {package_path}")

        for source_file, target_link in self.iter_stow_pairs(package_name):
            if not target_link.is_symlink():
                self._log(3, f"Not a symlink: {self._format_path(target_link)}")
                continue

            if not self._is_owned_by_package(target_link, package_path):
                self._log(2, f"Not owned by package: {self._format_path(target_link)}")
                continue

            self._log(0, f"Unstowing: {self._format_path(target_link)}")
            if not self.simulate:
                target_link.unlink()

                # Try to remove empty parent directories
                parent = target_link.parent
                while parent != self.target_dir:
                    try:
                        parent.rmdir()
                        parent = parent.parent
                    except OSError:
                        break

    def restow(self, package_name: str) -> None:
        """
        Restow a package (unstow then stow).

        Args:
            package_name: Name of the package to restow
        """
        self.unstow(package_name)
        self.stow(package_name)

    def is_stowed(self, package_name: str) -> bool:
        """
        Check if a package is currently stowed.

        Args:
            package_name: Name of the package to check

        Returns:
            True if all files are properly stowed, False otherwise
        """
        package_path = self._get_package_path(package_name)

        if not package_path.exists():
            return False

        for source_file, target_link in self.iter_stow_pairs(package_name):
            if not target_link.is_symlink():
                return False
            if not self._is_owned_by_package(target_link, package_path):
                return False
        return True


def main():
    parser = argparse.ArgumentParser(
        description="stowpy - A Python implementation of GNU Stow",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("-V", "--version", action="version", version=f"%(prog)s {'.'.join(map(str, __version__))}")

    parser.add_argument(
        "-d",
        "--dir",
        type=Path,
        default=Path(__file__).parent.resolve(),
        help="Set stow dir to DIR (default is stow.py directory)",
    )
    parser.add_argument(
        "-t",
        "--target",
        type=Path,
        help="Set target to DIR (default is parent of stow dir)",
    )
    parser.add_argument(
        "-S", "--stow", action="store_true", help="Stow the package names that follow"
    )
    parser.add_argument(
        "-D", "--delete", action="store_true", help="Unstow the package names that follow"
    )
    parser.add_argument(
        "-R", "--restow", action="store_true", help="Restow (unstow then stow)"
    )
    parser.add_argument("--ignore", type=str, help="Ignore files ending in this regex")
    parser.add_argument(
        "--defer", type=str, help="Don't stow files matching this regex if already stowed elsewhere"
    )
    parser.add_argument(
        "--override",
        type=str,
        help="Force stowing files matching this regex if already stowed elsewhere",
    )
    parser.add_argument(
        "--adopt", action="store_true", help="Import existing files into stow package from target"
    )
    parser.add_argument(
        "--simulate",
        action="store_true",
        help="Do not actually make any filesystem changes",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="Increase verbosity (can be specified multiple times, default: 2)",
    )

    parser.add_argument("packages", nargs="*", help="Package names to stow/unstow (default: all packages)")

    args = parser.parse_args()

    # Determine target directory
    if args.target is None:
        target_dir = args.dir.parent
    else:
        target_dir = args.target

    # Determine action (default to stow if no action specified)
    if args.delete:
        action = "unstow"
    elif args.restow:
        action = "restow"
    else:
        action = "stow"

    # Create stow instance
    stow = Stow(
        stow_dir=args.dir,
        target_dir=target_dir,
        simulate=args.simulate,
        verbose=args.verbose + 1 if args.simulate else args.verbose,
        ignore=args.ignore,
        defer=args.defer,
        override=args.override,
        adopt=args.adopt,
    )

    # Determine packages to operate on
    packages = args.packages
    if not packages:
        # Get all packages in stow_dir, applying ignore pattern
        ignore_pattern = re.compile(args.ignore) if args.ignore else None
        for item in stow.stow_dir.iterdir():
            if not item.is_dir():
                continue
            # Skip hidden directories
            if item.name.startswith("."):
                continue
            # Skip packages starting with "ignore-"
            if item.name.startswith("ignore-"):
                stow._log(2, f"Ignoring package: {item.name}")
                continue
            # Apply ignore pattern to directory names
            if ignore_pattern and ignore_pattern.search(item.name):
                stow._log(2, f"Ignoring package: {item.name}")
                continue
            packages.append(item.name)
        stow._log(1, f"No packages specified, operating on all packages: {packages}")

    # Execute action for each package
    has_errors = False
    for package in packages:
        try:
            if action == "stow":
                stow.stow(package)
            elif action == "unstow":
                stow.unstow(package)
            elif action == "restow":
                stow.restow(package)
        except (FileNotFoundError, FileExistsError, NotADirectoryError) as e:
            print(f"Error processing package '{package}': {e}", file=sys.stderr)
            has_errors = True
            continue

    # Exit with error code if any package failed
    if has_errors:
        sys.exit(1)


if __name__ == "__main__":
    main()
