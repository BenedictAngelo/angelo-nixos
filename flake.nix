{
  description = "Modular NixOS configuration for the nixos-btw host";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim.url = "github:pfassina/lazyvim-nix";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nix-flatpak,
    alejandra,
    lazyvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    mkSystem = {
      host,
      profile,
      users,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit
            inputs
            host
            profile
            users
            ;
          inherit lazyvim;
          username = builtins.head users;

          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };

        modules = [
          ./modules/core/overlays.nix
          ./profiles/${profile}
          nix-flatpak.nixosModules.nix-flatpak
          inputs.sops-nix.nixosModules.sops
        ];
      };
  in {
    nixosConfigurations = {
      # The only fully defined host in this repository snapshot.
      nixos-btw = mkSystem {
        host = "nixos-btw";
        profile = "nvidia-laptop";
        users = ["angelo"];
      };
    };

    formatter.${system} = inputs.alejandra.packages.${system}.default;
  };
}
