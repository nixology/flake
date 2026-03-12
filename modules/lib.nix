{ inputs, ... }:
let
  module = with inputs.std.components; nixology.std.lib;
in
module
