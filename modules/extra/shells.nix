{ inputs, ... }:
let
  module =
    { flake-parts-lib, lib, ... }:
    {
      options = {
        perSystem = flake-parts-lib.mkPerSystemOption (
          { pkgs, ... }:
          with lib;
          with types;
          let
            shells = mkOption {
              type = lazyAttrsOf shell;
              default = { };
              description = "Development shell configurations.";
            };

            shell = submodule {
              options = {
                inherit
                  inputsFrom
                  mkShellOverrides
                  packages
                  shellHook
                  stdenv
                  ;
              };
            };

            inputsFrom = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages whose inputs and shell hooks will be included in the development shell.";
            };

            mkShellOverrides = mkOption {
              type = lazyAttrsOf anything;
              default = { };
              description = "Overrides to apply to the development shell.";
            };

            packages = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages to include in development shell.";
            };

            shellHook = mkOption {
              type = lines;
              default = "";
              description = "Shell hook script to run when entering the development shell.";
            };

            stdenv = mkOption {
              type = package;
              default = pkgs.stdenvNoCC;
              description = "The stdenv to use for the development shell.";
            };
          in
          {
            options = { inherit shells; };
          }
        );
      };

      config = {
        perSystem =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          lib.mkIf (config.shells != { }) {
            devShells = lib.mapAttrs (
              name: shell:
              pkgs.mkShell.override shell.mkShellOverrides {
                inherit name;
                inherit (shell)
                  inputsFrom
                  packages
                  shellHook
                  stdenv
                  ;
              }
            ) config.shells;
          };
      };
    };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.systems.default
      nixology.flake.devShells
    ];
    meta = {
      shortDescription = "development shell configurations";
    };
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.extra.shells = component;
  };
}
