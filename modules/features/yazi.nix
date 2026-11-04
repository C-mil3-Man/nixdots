{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
        inherit pkgs;
        # Only overrides of yazi's built-in defaults live here.
        settings.yazi = {
          mgr = {
            ratio = [
              1
              4
              3
            ];
            sort_sensitive = false;
            show_hidden = true;
            scrolloff = 5;
          };

          opener.pdff = [
            {
              run = "sioyek --new-instance \"$@\"";
              desc = "sioyek";
              block = false;
              orphan = true;
              for = "unix";
            }
          ];

          open.prepend_rules = [
            {
              mime = "application/pdf";
              use = [
                "pdff"
                "reveal"
              ];
            }
          ];
        };
      };
    };
}
