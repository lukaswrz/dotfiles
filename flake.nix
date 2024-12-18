{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        pkgs,
        self',
        ...
      }: {
        packages.plow = pkgs.callPackage ./plow {};

        devShells.default = pkgs.mkShellNoCC {
          PLOW_FROM = "./home";

          packages = [self'.packages.plow];
        };
      };
    };
}
