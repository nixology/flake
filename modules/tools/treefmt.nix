{ config, inputs, ... }:
let
  treefmt = config.partitions.development.extraInputs.treefmt;

  module = {
    imports = [ treefmt.flakeModule ];
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.extra.shellEnvs
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
