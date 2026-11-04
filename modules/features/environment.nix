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
      packages.terminal = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;
        imports = [ self.wrapperModules.kitty ];
        extraConfig = ''
          shell ${lib.getExe self'.packages.shell-environment}
        '';
      };

      packages.shell-environment = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = self'.packages.zsh;
        runtimeInputs = [
          self'.packages.nh
          self'.packages.ns
          self'.packages.openv
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
