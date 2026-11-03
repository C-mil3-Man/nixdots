{ inputs, ... }:
{
  flake.nixosModules.core =
    { pkgs, lib, ... }:
    {
      # --- Networking Infrastructure ---
      networking.networkmanager.enable = true;

      # --- Hardware & Bluetooth Services ---
      hardware.bluetooth.enable = true;

      # --- Power & Battery Management Services ---
      services.power-profiles-daemon.enable = lib.mkDefault true;
      services.upower.enable = true;

      # --- Essential Desktop Services ---
      services.printing.enable = false;
      services.fwupd.enable = true;
      services.fstrim.enable = true;
      services.udisks2.enable = true;
      services.gvfs.enable = true;

      # --- Multimedia & Audio Infrastructure (Pipewire) ---
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      environment.systemPackages = [ pkgs.pavucontrol ];
    };
}
