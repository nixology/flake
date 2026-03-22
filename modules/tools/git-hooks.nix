{ config, inputs, ... }:
let
  git-hooks = config.partitions.development.extraInputs.git-hooks;

  module = {
    imports = [ git-hooks.flakeModule ];
    perSystem =
      { config, ... }:
      with config.pre-commit;
      {
        environments.default.packages = settings.enabledPackages;
        environments.default.shellHook = shellHook;
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.extra.environments
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
