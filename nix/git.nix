{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    init.defaultBranch = "main";
    pull.rebase = true;
    rebase.autoStash = true;
    merge.tool = "code";
    extraConfig = {
      "mergetool \"code\"" = {
        cmd = "code --wait --merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
      };
    };
  };
}
