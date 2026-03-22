{ inputs, ... }:
let
  module = with inputs.std.inputs.flake-parts.flakeModules; {
    imports = [ flakeModules ];
    config = {
      flake.schemas.flakeModules = schema;
    };
  };

  schema = {
    version = 1;
    doc = ''
      The `flakeModules` flake output contains flake-parts modules for use by other flakes.
    '';
    inventory = _output: { what = "flake-parts modules for use by other flakes"; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      shortDescription = "flake-parts modules for use by other flakes";
    };
  };
in
{
  flake.components = {
    nixology.flake.flakeModules = component;
  };
}
