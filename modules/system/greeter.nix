{ inputs, ... }:
{
  flake.nixosModules.greeter =
    { config, ... }:
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      services.xserver.enable = true;

      services.displayManager.noctalia-greeter = {
        enable = true;
        settings = {
          appearance = {
            hide_logo = true;
            password_style = "random";
            scheme_selector_position = "hidden"; # theme managed by noctalia
          };
          user.default = config.preferences.user.name;
          idle.timeout = 60;
        };
        passwordless-sync-users = [ config.preferences.user.name ];
      };
    };
}
