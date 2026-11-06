{ self, ... }:
{
  flake.nixosModules.users =
    { pkgs, config, ... }:
    {

      users.users."${config.preferences.user.name}" = {
        isNormalUser = true;
        description = config.preferences.user.name;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "input"
          "bluetooth"
        ];
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment;
      };
    };
}
