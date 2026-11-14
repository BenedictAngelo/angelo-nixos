{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;

    # --- ICONS ---
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # --- CURSOR ---
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    nwg-look
  ];
}
