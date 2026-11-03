{ self, inputs, ... }: {
  flake.nixosModules.opentofu = { pkgs, lib, config, ... }: {
    environment.systemPackages = with pkgs; [
      opentofu
      tofu-ls
    ];
  };
}
