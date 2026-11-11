{ self, inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
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
        # gnome-desktop dropped RRScreen, which breaks Lutris' display
        # manager fallback outside GNOME. Without it Lutris uses its legacy one.
        (lutris.override {
          lutris-unwrapped = lutris-unwrapped.overrideAttrs (old: {
            buildInputs = builtins.filter (p: (p.pname or "") != "gnome-desktop") old.buildInputs;
          });
        })
        protonup-qt
        winetricks
        vulkan-tools
      ];
    };
}
