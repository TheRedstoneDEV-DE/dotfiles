{
description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "http://nix-cache.homelab.local:8080" 
    ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # waybar = {
    #  url = "github:Alexays/Waybar";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    custom-overrides = {
      url = "github:TheRedstoneDEV-DE/nix-overrides";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #zen-browser = {
    #  url = "github:youwen5/zen-browser-flake";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    check_mk_agent = {
      url = "github:BenediktSeidl/nixos-check_mk_agent-overlay";
      # optional:
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuxedo-rs.url = "github:TheRedstoneDEV-DE/tuxedo-rs/gemini-fix";
  };

  outputs = { nixpkgs, nixpkgs-stable, nixpkgs-unstable, custom-overrides, home-manager, check_mk_agent,  tuxedo-rs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
      pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
    in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit pkgs-stable;
        inherit pkgs-unstable;
        inherit nixpkgs;
      };
      modules = [
        {
          nixpkgs.overlays = [ 
            custom-overrides.overrides inputs.millennium.overlays.default 
            (final: prev: {
              # Pull tuxedo-rs from your local flake's packages
              tuxedo-rs = tuxedo-rs.packages.x86_64-linux.tuxedo-rs;

              # Pull tailor-gui from your local flake too, so it doesn't
              # use nixpkgs's broken cross-reference to tuxedo-rs.src.name
              tailor-gui = tuxedo-rs.packages.x86_64-linux.tailor-gui;
            })
          ];
        }
        ./configuration.nix
        check_mk_agent.nixosModules.check_mk_agent
        	({ pkgs, ... }: {
              services.check_mk_agent = {
                enable = true;
                bind = "0.0.0.0";
                openFirewall = true;
                package = pkgs.check_mk_agent.override {
                enablePluginSmart = true;
              };
            };
          })
         home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit system inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.robert = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
      ];
    };
  };
}
