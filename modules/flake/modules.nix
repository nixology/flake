{ inputs, ... }:
let
  module = with inputs.std.inputs.flake-parts.flakeModules; {
    imports = [ modules ];
    config = {
      flake.schemas.modules = schema;
    };
  };

  schema = {
    version = 1;
    doc = ''
      The `modules` flake output contains modules for any module system.
    '';
    inventory = _output: { what = "modules for use by other module systems"; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      shortDescription = "modules for use by other module systems";
    };
  };
in
{
  imports = [ module ];
  flake.components = {
    nixology.flake.modules = component;
  };
}
