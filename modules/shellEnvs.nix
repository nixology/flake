{
  partitions.development.module = {
    perSystem =
      { config, ... }:
      {
        shellEnvs.default = config.shellEnvs.nix;
      };
  };
}
