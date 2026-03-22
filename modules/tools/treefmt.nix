{ config, inputs, ... }:
let
  treefmt = config.partitions.development.extraInputs.treefmt;

  module = {
    imports = [ treefmt.flakeModule ];
    perSystem =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        treefmt = {
          package = pkgs.treefmt;
          programs = {
            nixfmt.enable = lib.mkDefault true;
            shfmt.enable = lib.mkDefault true;
            deadnix.enable = lib.mkDefault true;
            keep-sorted.enable = lib.mkDefault true;
            nixf-diagnose = {
              enable = lib.mkDefault true;
              excludes = lib.mkDefault [ config.treefmt.projectRootFile ];
            };
          };
        };
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.flake.checks
      nixology.flake.formatter
      nixology.systems.default
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.tools.treefmt = component;
  };
}
