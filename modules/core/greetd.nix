{
  pkgs,
  username,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit
    (vars)
    barChoice
    ;
  shell =
    if barChoice == "noctalia-hyprland" || barChoice == "hyprland"
    then [
      "start-hyprland"
    ]
    else "niri-session";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${shell}"; # start Hyprland with a TUI login manager
      };
    };
  };
}
