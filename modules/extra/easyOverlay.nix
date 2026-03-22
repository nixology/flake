{ inputs, ... }:
let
  module = with inputs.std.inputs.flake-parts.flakeModules; easyOverlay;

  component = {
    inherit module;
    meta = {
      shortDescription = "module for easy overlay management";
    };
  };
in
{
  flake.components = {
    nixology.extra.easyOverlay = component;
  };
}
