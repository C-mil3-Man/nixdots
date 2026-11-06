{ inputs, ... }:
{
  flake.nixosModules.noctalia =
    { pkgs, config, ... }:
    let
      user = config.preferences.user.name;
      inherit (config.users.users.${user}) home group;
    in
    {
      # Noctalia v5 from its own flake (cachix cache applies)
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      # Declared config: symlink noctalia.toml into the home dir, Noctalia reads
      # every *.toml in ~/.config/noctalia/. GUI changes land in
      # ~/.local/state/noctalia/settings.toml and override this file.
      systemd.tmpfiles.rules = [
        "d ${home}/.config/noctalia 0755 ${user} ${group} -"
        "L+ ${home}/.config/noctalia/config.toml - - - - ${./noctalia.toml}"
      ];

      # Noctalia's wifi, bluetooth, power-profile and battery features rely on
      # NetworkManager, bluez, power-profiles-daemon and upower (see core.nix).

      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
}
