{
  description = "A collection of flake components for various purposes.";

  inputs.core.url = "github:nixology/core";

  outputs =
    inputs: with inputs.core.lib; mkFlake { inherit inputs; } { imports = modulesIn ./modules; };
}
