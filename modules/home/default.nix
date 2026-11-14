{host, ...}: let
  vars = import ../../hosts/${host}/variables.nix;

  inherit
    (vars)
    shellChoice
    barChoice
    tmuxEnable
    vscodeEnable
    terminalChoice
    helixEnable
    geminiEnable
    ;

  # -----------------------------
  # Shell module
  # -----------------------------
  shellModule =
    if shellChoice == "zsh"
    then ./zsh
    else ./fish/fish.nix;

  # -----------------------------
  # Terminal module
  # -----------------------------
  terminalModule =
    {
      kitty = ./terminals/kitty.nix;
      ghostty = ./terminals/ghostty.nix;
      wezterm = ./terminals/wezterm.nix;
      alacritty = ./terminals/alacritty.nix;
    }
    .${
      if terminalChoice == null
      then "ghostty"
      else terminalChoice
    };

  # -----------------------------
  # Desktop / WM stack
  # -----------------------------
  desktopModules =
    if barChoice == "noctalia-hyprland"
    then [
      ./hyprland
      ./noctalia/noctalia-hyprland.nix
      ./stylix.nix
      ./scripts
      ./rofi
      ./wlogout
      ./swaync.nix
    ]
    else if barChoice == "hyprland"
    then [
      ./hyprland
      ./stylix.nix
      ./scripts
      ./rofi
      ./wlogout
      ./swaync.nix
    ]
    # niri + noctalia fallback
    else [
      ./niri/niri.nix
      ./noctalia/noctalia-niri.nix
    ];

  # -----------------------------
  # Optional features
  # -----------------------------
  optionalModules =
    (
      if helixEnable
      then [./editors/evil-helix.nix]
      else []
    )
    ++ (
      if vscodeEnable
      then [./editors/vscode.nix]
      else []
    )
    ++ (
      if geminiEnable
      then [
        ./scripts/gemini-cli.nix
        ./amfora.nix
      ]
      else []
    )
    ++ (
      if tmuxEnable
      then [./terminals/tmux.nix]
      else []
    );
in {
  imports =
    [
      ./bash.nix
      ./bashrc-personal.nix
      ./overview.nix
      ./development/development.nix
      ./cli/bat.nix
      ./cli/btop.nix
      ./cli/cava.nix
      ./emoji.nix
      ./eza.nix
      ./fastfetch
      ./cli/fzf.nix
      ./cli/gh.nix
      ./cli/git.nix
      ./gtk.nix
      ./cli/lazygit.nix
      ./obs-studio.nix
      ./editors/lazyvim.nix
      ./editors/nano.nix
      ./editors/obsidian.nix
      ./editors/zed.nix
      ./qt.nix
      ./swappy.nix
      ./tealdeer.nix
      ./games/minecraft.nix
      ./virtmanager.nix
      ./xdg.nix
      ./yazi
      ./zen-browser.nix
      ./zoxide.nix

      shellModule
      terminalModule
    ]
    ++ desktopModules
    ++ optionalModules;
}
