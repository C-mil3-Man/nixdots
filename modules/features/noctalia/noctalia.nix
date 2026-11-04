{ inputs, ... }:
{
  flake.nixosModules.noctalia =
    { pkgs, ... }:
    {
      # Noctalia v5 from its own flake (cachix cache applies)
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      # Declared config: symlink noctalia.toml into the home dir, Noctalia reads
      # every *.toml in ~/.config/noctalia/. GUI changes land in
      # ~/.local/state/noctalia/settings.toml and override this file.
      systemd.tmpfiles.rules = [
        "d /home/crux/.config/noctalia 0755 crux users -"
        "L+ /home/crux/.config/noctalia/config.toml - - - - ${./noctalia.toml}"
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
