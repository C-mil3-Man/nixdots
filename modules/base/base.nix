# modules/base/base.nix
{ ... }:
{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.preferences.user.name = lib.mkOption {
        type = lib.types.str;
        description = "Primary user's login name";
      };
    };
}
