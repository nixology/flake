{
  config,
  inputs,
  moduleLocation,
  ...
}:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module =
    { lib, ... }:
    with lib;
    {
      options = {
        flake.homeModules = mkOption {
          type = types.lazyAttrsOf types.deferredModule;
          default = { };
          apply = mapAttrs (
            k: v: {
              _class = "home";
              _file = "${toString moduleLocation}#homeModules.${k}";
              imports = [ v ];
            }
          );
          description = ''
            Home Manager modules.

            You may use this for reusable pieces of configuration, service modules, etc.
          '';
          example = literalExpression ''
            homeModules.bash= { pkgs, ... }: {
              programs.bash = {
                enable = true;
                shellAliases = {
                  ll = "ls -l";
                };
              };
              home.packages = [ pkgs.hello ];
            };
          '';
        };
      };

      config = {
        flake.schemas = { inherit (flake-schemas.schemas) homeModules; };
      };
    };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      description = "Home Manager modules";
      shortDescription = "home manager modules";
    };
  };
in
{
  flake.components = {
    nixology.flake.homeModules = component;
  };
}
