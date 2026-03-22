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
        flake.darwinModules = mkOption {
          type = types.lazyAttrsOf types.deferredModule;
          default = { };
          apply = mapAttrs (
            k: v: {
              _class = "darwin";
              _file = "${toString moduleLocation}#darwinModules.${k}";
              imports = [ v ];
            }
          );
          description = ''
            Darwin modules.

            You may use this for reusable pieces of configuration, service modules, etc.
          '';
          example = ''
            configuration = { pkgs, ... }: {
              # Define system packages
              environment.systemPackages = [
                pkgs.vim
                pkgs.wget
              ];

              # Configure the shell
              programs.zsh.enable = true;
            };
          '';
        };
      };

      config = {
        flake.schemas = { inherit (flake-schemas.schemas) darwinModules; };
      };
    };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      description = "Darwin modules";
      shortDescription = "darwin modules";
    };
  };
in
{
  flake.components = {
    nixology.flake.darwinModules = component;
  };
}
