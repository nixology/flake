{
  description = "A flake that provides flake schemas";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  inputs = {
    std-flake-schemas.url = "git+ssh://git@github.com/marksisson/std?dir=partitions/schemas";
    flake-schemas.follows = "std-flake-schemas/flake-schemas";
  };
}
