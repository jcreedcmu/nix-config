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
    ".site-lisp/location.el".text = ''
    (setq location 'dell-laptop)
    '';
    "bin/tangle.pl".source = emacs/tangle.pl;
    ".emacs".source = emacs/init.el;
    ".config/emacs/emacs-config.org".source = emacs/readme.org;
    ".site-lisp/notes-mode.el".source = emacs/notes-mode.el;
  };

  # I imperatively installed
  # - iosevka.ttc
  # in ~/.local/share/fonts
  # (per advice in https://nixos.wiki/wiki/Fonts)
  # even though there are less impure ways of doing that.

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
	      font = "Monospace 12";
     };
     themeVariant = "dark";
     showMenubar = false;
   };
}
