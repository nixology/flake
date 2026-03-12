{ inputs, ... }:
let
  module = {
    perSystem = { config, lib, pkgs, ... }:
      {
        devShells =
          lib.mapAttrs
            (name: shell: pkgs.mkShell.override shell.mkShellOverrides {
              inherit (shell) inputsFrom name packages shellHook stdenv;
            })
            config.shells;
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.parts.shells
      nixology.systems.default
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = { nixology.parts.devShells = component; };
}
