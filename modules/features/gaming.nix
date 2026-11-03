{ self, inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
      hardware.graphics.enable = lib.mkDefault true;
      hardware.steam-hardware.enable = true;
      programs = {
        steam = {
          enable = true;
          protontricks.enable = true;
          package = pkgs.steam.override {
            extraArgs = "-system-composer";
          };
        };
        gamemode.enable = true;
        gamescope = {
          enable = true;
          capSysNice = true;
          args = [
            "--rt"
            "--expose-wayland"
          ];
        };
      };
      environment.systemPackages = with pkgs; [
        steam-run
        usbutils

        #For WoW/Battlenet
        lutris
        protonup-qt
        winetricks
        vulkan-tools
      ];
    };
}
