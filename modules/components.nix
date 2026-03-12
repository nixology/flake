{ inputs, lib, ... }: {
  imports = with inputs.std.components; [
    nixology.std.components
  ];

  # export std components as top-level components
  flake.components = with lib;
    # convert modules to components
    mapAttrs
      (_: mapAttrs (_: mapAttrs (_: module:
        let
          component = {
            inherit module;
          };
        in
        component)))
      inputs.std.components;
}
