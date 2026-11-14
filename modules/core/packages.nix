{
  pkgs,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;

  inherit
    (vars)
    barChoice
    geminiEnable
    ;

  isHyprland = barChoice == "hyprland" || barChoice == "noctalia-hyprland";

  isNoctalia = barChoice == "noctalia-niri" || barChoice == "noctalia-hyprland";

  isNiriWithSatellite = barChoice == "niri" || barChoice == "noctalia-niri";

  # Temporary niri patch
  niriPatched = pkgs.niri.override {
    libdisplay-info = pkgs.libdisplay-info.overrideAttrs (finalAttrs: {
      version = "0.3.0";

      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "emersion";
        repo = "libdisplay-info";
        rev = finalAttrs.version;
        hash = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
      };
    });
  };

  shellModule =
    if isHyprland
    then {
      hyprland = {
        enable = true;
        withUWSM = false;
      };

      hyprlock.enable = true;
    }
    else {
      niri.package = niriPatched;
      niri.enable = true;
    };

  noctaliaPkgs =
    if isNoctalia
    then
      with pkgs; [
        matugen
        app2unit
        gpu-screen-recorder
      ]
    else [
    ];

  hyprlandPkgs =
    if isHyprland
    then
      with pkgs; [
        uwsm
        waybar
        waypaper
        nwg-displays
        nwg-drawer
        nwg-dock-hyprland
        nwg-menu
        awww
      ]
    else [];

  optionalPkgs =
    if geminiEnable
    then [pkgs.amfora]
    else [];
in {
  programs =
    {
      neovim = {
        enable = true;
        defaultEditor = true;
      };

      firefox.enable = false;

      dconf.enable = true;
      seahorse.enable = true;

      fuse.userAllowOther = true;
      mtr.enable = true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }
    // shellModule;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  environment.systemPackages = with pkgs;
    [
      alejandra
      appimage-run
      brightnessctl
      cliamp
      cliphist
      cmatrix
      cowsay
      docker-compose
      duf
      eza
      ffmpeg
      file-roller
      gearlever
      icu
      gimp
      mesa-demos
      tuigreet
      home-manager
      inxi
      killall
      kew
      libdisplay-info
      libnotify
      libreoffice
      lm_sensors
      lolcat
      mdcat
      mpv
      ncdu
      nixfmt
      #onlyoffice-desktopeditors
      openssl
      pandoc
      pavucontrol
      pciutils
      picard
      playerctl
      ripgrep
      spotify
      sqlite
      socat
      unrar
      unzip
      usbutils
      upower
      v4l-utils
      wget
      ytmdl
      python3

      # Pkgs for secrets
      sops
      age
      (
        if isNiriWithSatellite
        then xwayland-satellite
        else xwayland
      )
    ]
    ++ noctaliaPkgs
    ++ hyprlandPkgs
    ++ optionalPkgs;
}
