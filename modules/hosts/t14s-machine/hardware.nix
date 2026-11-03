{ self, inputs, ... }: {
  flake.nixosModules.t14s-machine-hardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/5488b13c-e7c9-4834-b599-519833917598";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/A417-1600";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
