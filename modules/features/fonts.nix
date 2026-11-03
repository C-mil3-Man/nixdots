{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.fonts =
    { self, pkgs, ... }:
    {
      fonts = {
        fontconfig = {
          defaultFonts = {
            serif = [ "Ubuntu Sans" ];
            sansSerif = [ "Ubuntu Sans" ];
            monospace = [ "JetBrainsMono Nerd Font" ];
          };
        };
        packages =
          with pkgs;
          [
            # english
            ubuntu-sans
            corefonts
            unifont
          ]
          ++ [ pkgs.nerd-fonts.jetbrains-mono ];
      };
    };
}
