{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModule
    ./uhome.nix
  ];
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      zathura
      texliveMedium
      (python3.withPackages(ps: with ps; [
        python-lsp-server
        flake8
        rust-analyzer
      ]))
    ];
    extraPlugins = "return {
      {\"neovim/nvim-lspconfig\", lazy=false},
      {\"tidalcycles/vim-tidal\", lazy=false},
      {\"lervag/vimtex\",lazy=false,
        init = function()
          vim.g.vimtex_view_method = \"zathura\"
        end
      },
    }";
    extraConfig = "vim.lsp.enable('pylsp')
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('nixd')";
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "robert";
  home.homeDirectory = "/home/robert";
  programs.bash.enable = true;

  programs.bash.initExtra = ''
eval "$(fzf --bash)"
##-----------------------------------------------------
## synth-shell-prompt.sh
if [ -f /home/robert/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
  source /home/robert/.config/synth-shell/synth-shell-prompt.sh
fi

##-----------------------------------------------------
## better-ls
if [ -f /home/robert/.config/synth-shell/better-ls.sh ] && [ -n "$( echo $- | grep i )" ]; then
  source /home/robert/.config/synth-shell/better-ls.sh
fi

##-----------------------------------------------------
## alias
if [ -f /home/robert/.config/synth-shell/alias.sh ] && [ -n "$( echo $- | grep i )" ]; then
  source /home/robert/.config/synth-shell/alias.sh
fi

##-----------------------------------------------------
## better-history
if [ -f /home/robert/.config/synth-shell/better-history.sh ] && [ -n "$( echo $- | grep i )" ]; then
  source /home/robert/.config/synth-shell/better-history.sh
fi

export __HM_SESS_VARS_SOURCED=""
source ~/.profile
  '';
  home.shellAliases = {
    nano = "nvim";
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
    nixos-rebuild-switch = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    pkgs.home-manager
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.kde.okular.desktop"];
      "application/zip" = ["org.kde.ark.desktop"];
      "application/x-compressed-tar" = ["org.kde.ark.desktop"];
      "application/java-archive" = ["org.kde.ark.desktop"];
      "text/csv" = ["org.kde.kate.desktop"];
      "text/html" = ["librewolf.desktop"];
      "application/js" = ["codium.desktop"];
      "test/css" = ["codium.desktop"];
      "video/ogg" = ["vlc.desktop"];
      "audio/ogg" = ["vlc.desktop"];
      "audio/wav" = ["vlc.desktop"];
      "audio/webm" = ["vlc.desktop"];
      "video/webm" = ["vlc.desktop"];
      "audio/mpeg" = ["vlc.desktop"];
      "video/mp4" = ["vlc.desktop"];
      "video/mpeg" = ["vlc.desktop"];
      "application/x-sh" = ["org.kde.kate.desktop"];
      "application/xml" = ["org.kde.kate.desktop"];
      "text/plain" = ["org.kde.kate.desktop"];
      "application/json" = ["org.kde.kate.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"];
      "application/x-7z-compressed" = ["org.kde.ark.desktop"];
      "application/x-blender" = ["blender.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.kde.okular.desktop"];
      "application/zip" = ["org.kde.ark.desktop"];
      "application/x-compressed-tar" = ["org.kde.ark.desktop"];
      "application/java-archive" = ["org.kde.ark.desktop"];
      "text/csv" = ["org.kde.kate.desktop"];
      "text/html" = ["librewolf.desktop"];
      "application/js" = ["codium.desktop"];
      "test/css" = ["codium.desktop"];
      "video/ogg" = ["vlc.desktop"];
      "audio/ogg" = ["vlc.desktop"];
      "audio/wav" = ["vlc.desktop"];
      "audio/webm" = ["vlc.desktop"];
      "video/webm" = ["vlc.desktop"];
      "audio/mpeg" = ["vlc.desktop"];
      "video/mp4" = ["vlc.desktop"];
      "video/mpeg" = ["vlc.desktop"];
      "application/x-sh" = ["org.kde.kate.desktop"];
      "application/xml" = ["org.kde.kate.desktop"];
      "text/plain" = ["org.kde.kate.desktop"];
      "application/json" = ["org.kde.kate.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"];
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"];
      "application/x-7z-compressed" = ["org.kde.ark.desktop"];
      "application/x-blender" = ["blender.desktop"];
      "x-scheme-handler/http" = "librewolf.desktop"; 
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/steam" = "steam.desktop";
    };
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/alacritty".source = dotfiles/alacritty;
    ".config/gtk-3.0".source = dotfiles/gtk-3.0;
    ".config/hypr".source = dotfiles/hypr;
    #".config/nvim".source = dotfiles/nvim;
    ".config/qt5ct".source = dotfiles/qt5ct;
    ".config/qt6ct".source = dotfiles/qt6ct;
    ".config/synth-shell".source = dotfiles/synth-shell;
    ".config/waybar".source = dotfiles/waybar;
    ".config/wofi".source = dotfiles/wofi;
    ".config/wallpaper".source = dotfiles/wallpaper;
    ".config/sway".source = dotfiles/sway;
    ".config/swaylock".source = dotfiles/swaylock;
    ".config/rofi".source = dotfiles/rofi;
    #".bashrc".source = dotfiles/bashrc;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/robert/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "xterm-256color";
    TERMINAL = "alacritty";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
