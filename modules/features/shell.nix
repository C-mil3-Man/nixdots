{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      packages.shell-environment = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = self'.packages.zsh;
        runtimePkgs =
          map
            (p: {
              data = p;
              prefix = true;
            })
            [
              self'.packages.nh
              self'.packages.ns
              pkgs.manix
              pkgs.nix-inspect
              pkgs.libnotify
              pkgs.file
              pkgs.unzip
              pkgs.zip
              pkgs.p7zip
              pkgs.killall
              pkgs.sshfs
              pkgs.fzf
              pkgs.xdg-utils
              pkgs.ffmpeg-full
              pkgs.lazygit
              pkgs.dust
              pkgs.eza
              pkgs.imv
              pkgs.bat
              pkgs.awscli2
              self'.packages.git
              self'.packages.yazi
              self'.packages.btop
              self'.packages.neovim-nvf
            ];
        # required so it can be used as a login shell (users.users.<name>.shell)
        passthru.shellPath = "/bin/zsh";
        env = {
          EDITOR = lib.getExe self'.packages.neovim-nvf;
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_QPA_PLATFORMTHEME = "qt6ct";
          BAT_THEME = "gruvbox-dark";
        };
      };
    };
}
