{
  description = "My dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f rec {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            treefmt = pkgs.treefmt;
          }
        );
    in
    {
      devShells = forAllSystems (
        { system, pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              # For weave
              pkgs.fish

              # Formatters
              pkgs.treefmt
              pkgs.nixfmt
              pkgs.prettier
              pkgs.taplo
              pkgs.ruff
            ];
          };
        }
      );

      formatter = forAllSystems ({ treefmt, ... }: treefmt);
    };
}
