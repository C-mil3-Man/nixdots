{ self, inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, lib, ... }:
    {
      programs.neovim = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-nvf;
      };
    };
}
