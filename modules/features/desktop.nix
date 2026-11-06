{ self, ... }:
{
  flake.nixosModules.desktop =
    { config, pkgs, ... }:
    {
      imports = [
        # wm
        self.nixosModules.niri
        # apps
        self.nixosModules.firefox
        self.nixosModules.gtk

        # desktop visuals
        self.nixosModules.fonts
      ];

      environment.systemPackages = with pkgs; [
        networkmanagerapplet
        nautilus
      ];

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Standard for most DEs/WMs
        config.common.default = "*"; # Ensures a fallback portal is used
      };
    };
}
