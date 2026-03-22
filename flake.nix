{
  description = "A collection of flake components for various purposes.";

  inputs.std.url = "git+ssh://git@github.com/marksisson/std";

  outputs =
    inputs: with inputs.std.lib; mkFlake { inherit inputs; } { imports = modulesIn ./modules; };
}
