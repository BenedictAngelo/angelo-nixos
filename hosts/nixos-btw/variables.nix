{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "angelo";
  gitEmail = "BenedictAngelo@protonmail.com";

  # Set Displau Manager
  # `tui` for Text login
  # `sddm` for graphical GUI (default)
  # SDDM background is set with stylixImage
  displayManager = "tui";

  #fish, zsh
  shellChoice = "fish";

  # Choose between noctalia-niri, noctalia-hyprland, or hyprland
  barChoice = "noctalia-niri";

  # Emable/disable bundled applications

  vscodeEnable = false;
  tmuxEnable = false;

  # kitty, ghostty, wezterm, alacritty
  terminalChoice = "ghostty";

  # AI
  geminiEnable = false;

  # Note: This is evil-helix with VIM keybindings by default
  helixEnable = false;

  # Hyprland Settings
  extraMonitorSettings = "
   monitor = eDP-1,1920x1080@144.003,auto,1
    ";

  # Niri Settings
  niriMonitorSettings = ''
    output "eDP-1" {
        mode "1920x1080@144.003"
        scale 1
        transform "normal"
        position x=0 y=0
    }
  '';

  # Waybar Settings (used when barChoice = "waybar")
  clock24h = false;

  # Program Options
  # Set Default Browser (google-chrome-stable for google-chrome)
  # This does NOT install your browser
  # You need to install it by adding it to the `packages.nix`
  # or as a flatpak
  browser = "zen-beta";

  # flatpak true or false
  flatpakEnable = false;

  # Host-level default applications (picked up by Home Manager xdg.mimeApps)
  # Uncomment and adjust the .desktop IDs to set per-host defaults.
  mimeDefaultApps = {
    #   # PDFs
    #   "application/pdf" = ["okular.desktop"];
    #   "application/x-pdf" = ["okular.desktop"];
    #   # Web browser
    #   "x-scheme-handler/http"  = ["google-chrome.desktop"];  # or brave-browser.desktop, firefox.desktop
    #   "x-scheme-handler/https" = ["google-chrome.desktop"];
    #   "text/html"              = ["google-chrome.desktop"];
    #   # Files
    #   "inode/directory" = ["thunar.desktop"];      # file manager
    #   "text/plain"      = ["nvim.desktop"];        # or code.desktop
    "image/*" = ["gimp.desktop"];
    "image/png" = ["gimp.desktop"];
    "image/jpeg" = ["gimp.desktop"];
    "image/jpg" = ["gimp.desktop"];
    "image/webp" = ["gimp.desktop"];
    "image/gif" = ["gimp.desktop"];
    "image/bmp" = ["gimp.desktop"];
    "image/tiff" = ["gimp.desktop"];

    "video/*" = ["mpv.desktop"];
    "text/plain" = ["nvim.desktop"]; # or code.desktop, org.gnome.TextEditor.desktop
    "application/zip" = ["org.gnome.FileRoller.desktop"]; # or xarchiver.desktop, peazip.desktop
  };

  # Available Options:
  # Kitty, ghostty, wezterm, aalacrity
  terminal = "ghostty"; # Set Default System Terminal

  keyboardLayout = "us";
  keyboardVariant = "";
  consoleKeyMap = "us";

  # For hybrid support (Intel/NVIDIA Prime or AMD/NVIDIA)
  amdgpuID = "PCI:5:0:0";
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;

  # Enable Thunar GUI File Manager
  # Yazi is alternate File Manager
  thunarEnable = true;

  # Themes, waybar and animation.
  #  Only uncomment your selection
  # The others much be commented out.

  # Set Stylix Image
  # This will set your color palette
  # Default background
  # Add new images to ~/zaneyos/wallpapers
  #stylixImage = ../../wallpapers/mountainscapedark.jpg;
  #stylixImage = ../../wallpapers/AnimeGirlNightSky.jpg;
  #stylixImage = ../../wallpapers/Anime-Purple-eyes.png;
  stylixImage = ../../wallpapers/Rainnight.jpg;
  #stylixImage = ../../wallpapers/zaney-wallpaper.jpg;
  #stylixImage = ../../wallpapers/nix-wallpaper-stripes-logo.png;
  #stylixImage = ../../wallpapers/beautifulmountainscape.jpg;

  # Set Waybar
  #  Available Options:
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm-2.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jerry.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-TheBlackDon.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubsos-v1.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-mecha.nix;
  waybarChoice = ../../modules/home/waybar/waybar-jak-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jak-ml4w-modern.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jak-oglo-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-transparent.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-ultradark.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-pctrade-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-old-ddubsos.nix;

  # Set Animation style
  # Available options are:
  #animChoice = ../../modules/home/hyprland/animations-def.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-end-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  #animChoice = ../../modules/home/hyprland/animations-moving.nix;
  #animChoice = ../../modules/home/hyprland/animations-hyde-optimized.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-1.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-2.nix;
  animChoice = ../../modules/home/hyprland/animations-ml4w-classic.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-fast.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-high.nix;

  # Set network hostId if required (needed for zfs)
  # Otherwise leave as-is
  hostId = "5ab03f50";
}
