{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwm-src = {
      url = "git+file:///home/asoen/nixos-dotfiles/config/dwm";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, dwm-src, home-manager, ... }@inputs: {
    nixosConfigurations.ngunnawal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.asoen = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
