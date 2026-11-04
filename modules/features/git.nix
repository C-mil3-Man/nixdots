{
  self,
  lib,
  inputs,
  ...
}:
{
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
