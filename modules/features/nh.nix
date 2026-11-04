{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.nh = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.nh;
      env = {
        # let the shell expand $HOME at runtime
        NH_FLAKE = {
          data = "$HOME/nixdots";
          esc-fn = inputs.wrapper-modules.lib.escapeShellArgWithEnv;
        };
      };
    };
  };
}
