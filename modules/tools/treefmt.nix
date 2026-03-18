{ config, inputs, ... }:
let
  treefmt = config.partitions.development.extraInputs.treefmt;

  module = {
    imports = [ treefmt.flakeModule ];
    perSystem = { config, pkgs, ... }: {
      treefmt =
        {
          package = pkgs.treefmt;
          programs = {
            nixpkgs-fmt.enable = true;
            shfmt.enable = true;
            deadnix.enable = true;
            keep-sorted.enable = true;
            nixf-diagnose = {
              enable = true;
              excludes = [ config.treefmt.projectRootFile ];
            };
          };
        };

      environments.default.packages = with config.treefmt; builtins.attrValues build.programs;
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
      nixology.extra.environments
      nixology.systems.default
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = { nixology.tools.treefmt = component; };
}
