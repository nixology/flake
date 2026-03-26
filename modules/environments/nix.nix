{ inputs, ... }:
let
  module = {
    perSystem =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        shellEnvs.nix = {
          packages = with pkgs; [ nix-output-monitor ];
        };
        treefmt.programs = {
          nixfmt.enable = lib.mkDefault true;
          deadnix.enable = lib.mkDefault true;
          nixf-diagnose = {
            enable = lib.mkDefault true;
            excludes = lib.mkDefault [ config.treefmt.projectRootFile ];
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
      nixology.tools.treefmt
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.environments.nix = component;
  };
}
