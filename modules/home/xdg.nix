{
  pkgs,
  host,
  lib,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit (vars) barChoice;

  shellPortals =
    if
      barChoice
      == "hyprland"
      || barChoice == "noctalia-hyprland"
    then
      with pkgs; [
        xdg-desktop-portal-hyprland
      ]
    else
      with pkgs; [
        xdg-desktop-portal-gtk
      ];

  shellConfigPkgs =
    if
      barChoice
      == "hyprland"
      || barChoice == "noctalia-hyprland"
    then
      with pkgs; [
        hyprland
      ]
    else
      with pkgs; [
        niri
      ];
in {
  xdg = {
    enable = true;

    mime.enable = true;

    mimeApps = {
      enable = true;

      defaultApplications =
        lib.mkIf (vars ? mimeDefaultApps)
        vars.mimeDefaultApps;
    };

    portal = {
      enable = true;

      extraPortals = shellPortals;

      configPackages = shellConfigPkgs;
    };
  };
}
