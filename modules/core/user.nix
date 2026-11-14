{
  pkgs,
  inputs,
  username,
  host,
  profile,
  lazyvim,
  unstable,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;

  inherit
    (vars)
    gitUsername
    shellChoice
    ;

  shellActive =
    if shellChoice == "zsh"
    then pkgs.zsh
    else pkgs.fish;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;

    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        profile
        pkgs
        lazyvim
        unstable
        ;
    };

    users.${username} = {
      imports = [./../home];

      home = {
        inherit username;

        homeDirectory = "/home/${username}";
        stateVersion = "26.05";
      };
    };
  };

  users.mutableUsers = true;

  users.users.${username} = {
    isNormalUser = true;

    description = gitUsername;

    extraGroups = [
      "adbusers"
      "docker"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "wheel"
      "vboxusers"
    ];

    shell = shellActive;

    ignoreShellProgramCheck = true;
  };

  nix.settings.allowed-users = [username];
}
