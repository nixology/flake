{ config, inputs, ... }:
let
  git-hooks = config.partitions.development.extraInputs.git-hooks;

  module = {
    imports = [ git-hooks.flakeModule ];
    perSystem =
      { config, lib, ... }:
      with config.pre-commit;
      {
        shellEnvs = lib.mkIf (config.pre-commit.settings.enabledPackages != [ ]) {
          default = {
            packages = settings.enabledPackages;
            shellHook = shellHook;
          };
        };
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.extra.shellEnvs
      nixology.systems.default
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.tools.git-hooks = component;
  };
}
