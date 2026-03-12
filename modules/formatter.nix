{ config, inputs, ... }:
let
  development = config.partitions.development.extraInputs;

  module =
    {
      imports = [ development.treefmt.flakeModule ];
      perSystem = { config, pkgs, ... }:
        {
          treefmt =
            {
              projectRootFile = "flake.nix";
              package = pkgs.treefmt;
              programs = {
                nixpkgs-fmt.enable = true;
                shfmt.enable = true;
                deadnix.enable = true;
                keep-sorted.enable = true;
                nixf-diagnose.enable = true;
              };
            };

          shells.default.packages = with config.treefmt; builtins.attrValues build.programs;
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
  flake.components = { nixology.parts.formatter = component; };
}
