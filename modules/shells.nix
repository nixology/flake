{ inputs, ... }:
let
  module = { flake-parts-lib, lib, ... }: {
    options =
      {
        perSystem = flake-parts-lib.mkPerSystemOption ({ pkgs, ... }: with lib; with types;
          let
            shells = mkOption {
              type = lazyAttrsOf (submodule ({ name, ... }: {
                options = {
                  name = mkOption {
                    type = str;
                    default = name;
                    description = "Name of the development shell.";
                  };
                  inherit inputsFrom mkShellOverrides packages shellHook stdenv;
                };
              }));
              default = { };
              description = "Development shell configurations.";
            };

            inputsFrom = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages whose inputs will be included in the development shell.";
            };

            mkShellOverrides = mkOption {
              type = lazyAttrsOf anything;
              default = { stdenv = pkgs.stdenvNoCC; };
              description = "Overrides to apply to the development shell.";
            };

            packages = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages to include in development shell.";
            };

            shellHook = mkOption {
              type = lines;
              default = "";
              description = "Shell hook script to run when entering the development shell.";
            };

            stdenv = mkOption {
              type = package;
              # pkgs.pkgsLLVM.llvmPackages_latest.stdenv
              default = pkgs.stdenv;
              description = "The stdenv to use for the development shell.";
            };
          in
          {
            options = { inherit shells; };
          });
      };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.systems.default
    ];
  };
in
{
  imports = [ module ];
  flake.components = { nixology.parts.shells = component; };
}
