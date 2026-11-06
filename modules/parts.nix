{ self, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;

      checks.t14s-machine = self.nixosConfigurations.t14s-machine.config.system.build.toplevel;
    };
}
