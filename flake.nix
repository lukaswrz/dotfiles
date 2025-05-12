{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    weave.url = "git+https://codeberg.org/helvetica/weave.git";
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
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            inputs.weave.packages.${system}.default
          ];

          shellHook = ''
            root=$(git rev-parse --show-toplevel)

            export WEAVE_FROM=$root/home
            export WEAVE_HIST=$root/.weavehist
          '';
        };
      };
    };
}
