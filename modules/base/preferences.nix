# modules/base/preferences.nix
{ ... }:
{
  flake.nixosModules.preferences =
    { lib, ... }:
    {
      options.preferences.user.name = lib.mkOption {
        type = lib.types.str;
        description = "Primary user's login name";
      };
    };
}
