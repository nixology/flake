{ config, inputs, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  parts =
    let
      modules = {
        apps = "runnable programs";
        checks = "derivations for testing evaluation of this flake";
        devShells = "derivations that provide development environments";
        formatter = "package to use to format the project";
        legacyPackages = "nested attribute sets of nixpkgs packages";
        nixosConfigurations = "nixos configurations";
        nixosModules = "nixos modules";
        overlays = "nixpkgs overlays";
        packages = "nixpkgs packages";
      };
    in
    builtins.mapAttrs (
      name: description:
      let
        module = {
          imports = [ "${inputs.std.inputs.flake-parts}/modules/${name}.nix" ];
          config = {
            flake.schemas.${name} = flake-schemas.schemas.${name};
          };
        };

        component = {
          inherit module;
          dependencies = with inputs.self.components; [
            nixology.std.schemas
          ];
          meta = {
            shortDescription = description;
          };
        };
      in
      component
    ) modules;
in
{
  imports = map (component: component.module) [
    parts.checks
    parts.devShells
    parts.formatter
  ];
  flake.components = {
    nixology.flake = parts;
  };
}
