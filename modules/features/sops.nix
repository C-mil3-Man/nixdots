{ self, inputs, ... }:
{
  flake.nixosModules.mySops =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.sops
      ];

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";

        age = {
          keyFile = "/home/crux/.config/sops/age/keys.txt";
          generateKey = false;
        };

      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.sops = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.sops;
        # Environment baked into the package itself
        env.SOPS_AGE_KEY_FILE = "/home/crux/.config/sops/age/keys.txt";
      };
    };
}
