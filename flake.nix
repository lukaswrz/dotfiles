{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    weave.url = "git+https://codeberg.org/helvetica/weave.git";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = {
        system,
        pkgs,
        self',
        lib,
        ...
      }: {
        packages = lib.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ./packages;
        };

        devShells.default = pkgs.mkShellNoCC {
          packages = [
            inputs.weave.packages.${system}.default
          ];

          shellHook = ''
            root=$(git rev-parse --show-toplevel)

            export WEAVE_FROM=$root/home
            export WEAVE_HIST=$root/.weavecache
          '';
        };
      };
    };
}
