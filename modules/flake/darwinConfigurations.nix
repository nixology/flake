{ config, inputs, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module =
    { lib, ... }:
    with lib;
    {
      options = {
        flake.darwinConfigurations = mkOption {
          type = types.lazyAttrsOf types.raw;
          default = { };
          description = ''
            Instantiated Darwin configurations. Used by `darwin-rebuild`.

            `darwinConfigurations` is for specific machines. If you want to expose
            reusable configurations, add them to [`darwinModules`](#opt-flake.darwinModules)
            in the form of modules (no `nix-darwin.lib.darwinSystem`), so that you can reference
            them in this or another flake's `darwinConfigurations`.
          '';
          example = literalExpression ''
            {
              my-machine = inputs.nix-darwin.lib.darwinSystem {
                modules = [ ./configuration.nix ];
                specialArgs = { inherit inputs; };
              };
            }
          '';
        };
      };

      config = {
        flake.schemas = { inherit (flake-schemas.schemas) darwinConfigurations; };
      };
    };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      description = "Instantiated Darwin configurations";
      shortDescription = "darwin configurations";
    };
  };
in
{
  flake.components = {
    nixology.flake.darwinConfigurations = component;
  };
}
