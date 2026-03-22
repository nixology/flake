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
            environments = mkOption {
              type = lazyAttrsOf (
                submodule (
                  { name, ... }:
                  {
                    options = {
                      name = mkOption {
                        type = str;
                        default = name;
                        description = "Name of the development environment.";
                      };
                      inherit
                        inputsFrom
                        mkShellOverrides
                        packages
                        shellHook
                        stdenv
                        ;
                    };
                  }
                )
              );
              default = { };
              description = "Development environment configurations.";
            };

            inputsFrom = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages whose inputs will be included in the development environment.";
            };

            mkShellOverrides = mkOption {
              type = lazyAttrsOf anything;
              default = { };
              description = "Overrides to apply to the development environment.";
            };

            packages = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages to include in development environment.";
            };

            shellHook = mkOption {
              type = lines;
              default = "";
              description = "Shell hook script to run when entering the development environment.";
            };

            stdenv = mkOption {
              type = package;
              default = pkgs.stdenvNoCC;
              description = "The stdenv to use for the development environment.";
            };
          in
          {
            options = { inherit environments; };
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
          lib.mkIf (config.environments != { }) {
            devShells = lib.mapAttrs (
              name: environment:
              pkgs.mkShell.override environment.mkShellOverrides {
                inherit (environment)
                  inputsFrom
                  name
                  packages
                  shellHook
                  stdenv
                  ;
              }
            ) config.environments;
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
      shortDescription = "development environment configurations";
    };
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.extra.environments = component;
  };
}
