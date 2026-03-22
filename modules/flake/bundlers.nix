{ config, inputs, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module = with inputs.std.inputs.flake-parts.flakeModules; {
    imports = [ bundlers ];
    config = {
      flake.schemas = { inherit (flake-schemas.schemas) bundlers; };
    };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
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
