{ inputs, ... }:
{
  # export core components as top-level components
  flake.components = inputs.core.components;
}
