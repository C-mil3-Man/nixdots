{
  flake.nixosModules.power =
    { pkgs, ... }:
    {
      # Profiles are handled by power-profiles-daemon (enabled in core.nix).
      # Battery charge limits are written straight to the ThinkPad sysfs knobs.
      systemd.services.battery-charge-thresholds = {
        description = "Set battery charge thresholds";
        wantedBy = [
          "multi-user.target"
          "post-resume.target"
        ];
        after = [ "post-resume.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "battery-charge-thresholds" ''
            bat=/sys/class/power_supply/BAT0
            echo 40 > $bat/charge_control_start_threshold
            echo 80 > $bat/charge_control_end_threshold
          '';
        };
      };
    };
}
