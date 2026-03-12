{ config, inputs, ... }:
let
  development = config.partitions.development.extraInputs;

  module =
    {
      imports = [ development.git-hooks.flakeModule ];
      perSystem = { config, ... }: {
        shells.default.packages = with config.pre-commit; settings.enabledPackages;
        shells.default.shellHook = "${with config.pre-commit; shellHook}";
      };
    };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.parts.shells
      nixology.systems.default
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = { nixology.parts.checks = component; };
}
