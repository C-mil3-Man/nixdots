{
  flake.nixosModules.boot =
    { pkgs, ... }:
    {
      boot = {
        plymouth.enable = true;
        tmp.useTmpfs = true;
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
      };

      powerManagement.enable = true;
    };
}
