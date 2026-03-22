{ inputs, ... }:
{
  # export std components as top-level components
  flake.components = inputs.std.components;
}
