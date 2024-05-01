{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jcreed";
  home.homeDirectory = "/home/jcreed";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello
    dconf # this is crucial for actually applying gnome-terminal settings below!
          # see https://github.com/nix-community/home-manager/issues/3113

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bashrc".source = dotfiles/bashrc;
    ".gitconfig".source = dotfiles/gitconfig;
    ".git-prompt.bash".source = dotfiles/git-prompt.bash;
    ".git-completion.bash".source = dotfiles/git-completion.bash;
    ".config/i3/config".source = config/i3.config;
    "bin/change-workspace.js".source = pkgs.substituteAll {
      name = "change-workspace.js";
      src = ./bin/change-workspace.js;
      isExecutable = true;
      node = "${pkgs.nodejs_21}/bin/node";
    };

    
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jcreed/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.gnome-terminal = {
     enable = true;
     # this name needs to be a uuid
     # see https://github.com/nix-community/home-manager/issues/3923
     profile."b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        visibleName = "default";
        audibleBell = false;
	customCommand = "bash";
	default = true;
	font = "Monospace 10";
     };
     themeVariant = "dark";
     showMenubar = false;
   };


}
