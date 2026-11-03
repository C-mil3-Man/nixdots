{ lib, ... }:
{
  options.flake.wrapperModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
  };
}
