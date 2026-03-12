{ inputs, ... }:
let
  # define components for flake-parts modules
  parts = with inputs.std.inputs.flake-parts.flakeModules; {
    bundlers = { module = bundlers; };
    easyOverlay = { module = easyOverlay; };
    flakeModules = { module = flakeModules; };
    modules = { module = modules; };
    partitions = { module = partitions; };
  };
in
{
  imports = [ parts.partitions.module ];
  flake.components = { nixology = { inherit parts; }; };
}
