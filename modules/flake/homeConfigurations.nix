{ config, inputs, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module =
    { lib, ... }:
    with lib;
    {
      options = {
        flake.homeConfigurations = mkOption {
          type = types.lazyAttrsOf types.raw;
          default = { };
          description = ''
            Instantiated Home Manager configurations. Used by `home-manager`.

            `homeConfigurations` is for specific users. If you want to expose
            reusable configurations, add them to [`homeModules`](#opt-flake.homeModules)
            in the form of modules (no `home-manager.lib.homeManagerConfiguration`), so that you can reference
            them in this or another flake's `homeConfigurations`.
          '';
          example = literalExpression ''
            {
              my-machine = inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [
                  inputs.self.homeModules.bash
                  {
                    home.username = "alice";
                    home.homeDirectory = "/home/alice";
                    home.stateVersion = "25.11";
                  }
                ];
              };
            }
          '';
        };
      };

      config = {
        flake.schemas = { inherit (flake-schemas.schemas) homeConfigurations; };
      };
    };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      description = "Instantiated Home Manager configurations for specific users. Used by `home-manager`.";
      shortDescription = "home manager configurations";
    };
  };
in
{
  flake.components = {
    nixology.flake.homeConfigurations = component;
  };
}
