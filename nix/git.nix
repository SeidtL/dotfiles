{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "SeidtL";
        email = "SeidtL@163.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      merge.tool = "code";
      "mergetool \"code\"" = {
        cmd = "code --wait --merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
      };
      core.editor = "code";
      lfs.concurrenttransfers = 3;
      "lfs \"customtransfer.xet\"" = {
        path = "git-xet";
        args = "transfer";
        concurrent = true;
      };
    };
    ignores = [
      ".DS_Store"
    ];
  };
}
