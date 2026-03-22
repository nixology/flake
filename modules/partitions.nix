{ lib, ... }:
let
  development =
    let
      partition = "development";
    in
    {
      partitionedAttrs = lib.genAttrs [ "checks" "devShells" "formatter" ] (_: partition);
      partitions.${partition}.extraInputsFlake = ../partitions/${partition};
    };

  schemas =
    let
      partition = "schemas";
    in
    {
      partitionedAttrs = lib.genAttrs [ "schemas" ] (_: partition);
      partitions.${partition}.extraInputsFlake = ../partitions/${partition};
    };

  module = {
    imports = [
      development
      schemas
    ];
  };
in
module
