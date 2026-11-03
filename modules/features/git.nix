{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.nixosModules.git =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
        config.extraConfig.core = {
          sshCommand = "ssh -i ${config.sops.secrets.github_ssh_key.path} -o IdentitiesOnly=yes";
        };
      };
    };

  perSystem =
    {
      config,
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.git = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;
        settings = {
          init = {
            defaultBranch = "main";
          };
        };
      };
    };
}
