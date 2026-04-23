{ config, inputs, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module = with inputs.core.inputs.flake-parts.flakeModules; {
    imports = [ bundlers ];
    config = {
      flake.schemas = { inherit (flake-schemas.schemas) bundlers; };
    };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.core.schemas
    ];
    meta = {
      shortDescription = "functions that return bundled applications";
    };
  };
in
{
  flake.components = {
    nixology.flake.bundlers = component;
  };
}
