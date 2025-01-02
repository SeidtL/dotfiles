#!/usr/bin/env fish
set -l _tide_tmp_dir (command mktemp -d)
curl https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC $_tide_tmp_dir
command cp -R $_tide_tmp_dir/*/{completions,conf.d,functions} $__fish_config_dir
fish_path=(status fish-path) exec $fish_path -C "emit _tide_init_install"
