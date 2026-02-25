{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    weave.url = "git+https://hack.moontide.ink/m64/weave.git";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      devShells = forAllSystems (
        { system, pkgs, ... }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              inputs.weave.packages.${system}.default

              # Formatters
              pkgs.treefmt
              pkgs.nixfmt
              pkgs.prettier
              pkgs.taplo
              pkgs.fish
              pkgs.ruff
            ];
          };
        }
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.treefmt);
    };
}
