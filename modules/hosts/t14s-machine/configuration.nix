{ self, inputs, ... }:
{
  flake.nixosModules.t14s-machine-configuration = {
    imports = [
      # --- Hardware ---
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
      self.nixosModules.t14s-machine-hardware

      # --- System ---
      self.nixosModules.preferences
      self.nixosModules.boot
      self.nixosModules.locale
      self.nixosModules.users
      self.nixosModules.greeter
      self.nixosModules.nix
      self.nixosModules.core
      self.nixosModules.power
      self.nixosModules.apps-cli
      self.nixosModules.apps-media
      self.nixosModules.apps-social
      self.nixosModules.apps-dev

      # --- Desktop & extras ---
      self.nixosModules.desktop
      self.nixosModules.gaming
      self.nixosModules.noctalia
    ];

    networking.hostName = "t14s-machine";

    preferences.user.name = "crux";
    users.users.crux.hashedPassword = "$6$0sfQ8ixqLcqKfVzn$Bd7MrgBF67TKtyxKtOamW6KSZ87S0hi1W2D2gyR6w.CdsInDPAagTXAn7R2eCm7jd/mHdvE8l9k5W2JM55DxM0";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    system.stateVersion = "25.11";
  };
}
