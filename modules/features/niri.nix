{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    {
      self',
      pkgs,
      config,
      lib,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        # package = self'.packages.niri;
      };

      # from iynaix on the vimjoyer discord server
      # do not kick me out of a session on rebuild
      systemd.user.units."niri.service" = {
        # add to the existing service, as drop-in so it doesn't generate the other sections
        # had to do lib.mkdefault or it would throw hissy fit?
        overrideStrategy = lib.mkDefault "asDropin";
        text = lib.mkDefault ''
          [Service]
          X-StopIfChanged=false
          X-RestartIfChanged=false
        '';
      };
      # systemd.user.services.niri = {
      #   # add to the existing service, drop-in so it doesn't genreate the other sections
      #   overrideStrategy = "asDropin";
      #   stopIfChanged = false;
      #   restartIfChanged = false;
      # };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      config,
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        disableConfigHotReload = false;
        settings =
          let
            MainMod = "Mod";
            terminalExe = lib.getExe self'.packages.terminal;
            # fcitx5Exe = lib.getExe pkgs.fcitx5;
          in
          {
            # Noctalia v5 binary is just `noctalia`
            spawn-at-startup = [
              "noctalia"
            ];

            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

            cursor = {
              xcursor-theme = "macOS";
              xcursor-size = 19;
            };

            input = {
              keyboard = {
                # increasing repeat-delay and repeat-rate seems to make things much much better and faster
                repeat-delay = 200;
                repeat-rate = 40;
                xkb.layout = "us, se";
                xkb.options = "grp:alt_shift_toggle,caps:escape";
              };
              mouse.accel-profile = "flat";
            };

            outputs."eDP-1" = {
              scale = 1.0;
              variable-refresh-rate = _: { };
            };

            layout = {
              gaps = 3;
              focus-ring = {
                width = 0.5;
              };
              border = {
                off = _: { };
                # width = 0.5;
              };
              tab-indicator = {
                on = _: { };
                # hide-when-single-tab = _: { };
                gap = 0;
                width = 12;
                length = _: {
                  props = {
                    total-proportion = 0.8;
                  };
                };
                position = "top";
                gaps-between-tabs = 5;
                corner-radius = 2.0;
              };
            };

            window-rules = [
              {
                draw-border-with-background = false;
                # rounded corners for all windows
                geometry-corner-radius = 4;
                clip-to-geometry = true;
                open-maximized-to-edges = false;
              }
            ];

            blur = {
              on = _: { };
              passes = 2;
              noise = 0.05;
              offset = 3.0;
            };

            switch-events = {
              lid-open = _: {
                content = {
                  spawn = [
                    "notify-send"
                    "Wakeup bitch!"
                  ];
                };
              };
              lid-close = _: {
                content = {
                  spawn = [
                    "noctalia"
                    "msg"
                    "session"
                    "lock-and-suspend"
                  ];
                };
              };
            };

            prefer-no-csd = _: { };

            binds = {
              # -- KEYBINDINGS --
              # Terminal and Launcher
              "${MainMod}+Return".spawn-sh = "${terminalExe}";
              "${MainMod}+Space".spawn-sh = "noctalia msg panel-toggle launcher";
              "${MainMod}+S".spawn-sh = "noctalia msg panel-toggle control-center";
              "${MainMod}+Comma".spawn-sh = "noctalia msg settings-toggle";
              "${MainMod}+W".toggle-column-tabbed-display = _: { };

              # Screenshot
              "Print".screenshot = _: {
                props = {
                };
              };

              # Session Menu
              # FIXME: the exact command for the session menu isn't in the docs pages I read.
              # Check https://docs.noctalia.dev/noctalia/ipc/surfaces/ and adjust if needed.
              "Home".spawn-sh = "noctalia msg panel-toggle session";

              # Window Management
              "${MainMod}+Q".close-window = _: { };
              "${MainMod}+F".maximize-column = _: { };
              "${MainMod}+G".fullscreen-window = _: { };
              "${MainMod}+Shift+F".toggle-window-floating = _: { };
              "${MainMod}+V".center-column = _: { };

              # Navigation
              "${MainMod}+H".focus-column-or-monitor-left = _: { };
              "${MainMod}+J".focus-window-or-workspace-down = _: { };
              "${MainMod}+K".focus-window-or-workspace-up = _: { };
              "${MainMod}+L".focus-column-or-monitor-right = _: { };

              "${MainMod}+Left".focus-column-left = _: { };
              "${MainMod}+Right".focus-column-right = _: { };
              "${MainMod}+Up".focus-window-or-workspace-up = _: { };
              "${MainMod}+Down".focus-window-or-workspace-down = _: { };

              # Moving Windows

              "${MainMod}+Shift+H".move-column-left-or-to-monitor-left = _: { };
              "${MainMod}+Shift+J".move-window-down-or-to-workspace-down = _: { };
              "${MainMod}+Shift+K".move-window-up-or-to-workspace-up = _: { };
              "${MainMod}+Shift+L".move-column-right-or-to-monitor-right = _: { };

              "${MainMod}+Shift+Left".move-column-to-monitor-left = _: { };
              "${MainMod}+Shift+Down".move-column-to-monitor-down = _: { };
              "${MainMod}+Shift+Up".move-column-to-monitor-up = _: { };
              "${MainMod}+Shift+Right".move-column-to-monitor-right = _: { };

              "${MainMod}+Home".focus-column-first = _: { };
              "${MainMod}+End".focus-column-last = _: { };
              "${MainMod}+Ctrl+Home".move-column-to-first = _: { };
              "${MainMod}+Ctrl+End".move-column-to-last = _: { };

              "${MainMod}+1".focus-workspace = 1;
              "${MainMod}+2".focus-workspace = 2;
              "${MainMod}+3".focus-workspace = 3;
              "${MainMod}+4".focus-workspace = 4;
              "${MainMod}+5".focus-workspace = 5;
              "${MainMod}+6".focus-workspace = 6;
              "${MainMod}+7".focus-workspace = 7;
              "${MainMod}+8".focus-workspace = 8;
              "${MainMod}+9".focus-workspace = 9;
              "${MainMod}+Shift+1".move-column-to-workspace = 1;
              "${MainMod}+Shift+2".move-column-to-workspace = 2;
              "${MainMod}+Shift+3".move-column-to-workspace = 3;
              "${MainMod}+Shift+4".move-column-to-workspace = 4;
              "${MainMod}+Shift+5".move-column-to-workspace = 5;
              "${MainMod}+Shift+6".move-column-to-workspace = 6;
              "${MainMod}+Shift+7".move-column-to-workspace = 7;
              "${MainMod}+Shift+8".move-column-to-workspace = 8;
              "${MainMod}+Shift+9".move-column-to-workspace = 9;
              # The following binds move the focused window in and out of a column.
              # If the window is alone, they will consume it into the nearby column to the side.
              # If the window is already in a column, they will expel it out.
              "${MainMod}+BracketLeft".consume-or-expel-window-left = _: { };
              "${MainMod}+BracketRight".consume-or-expel-window-right = _: { };

              # --- Media Keys (via Noctalia IPC so the OSD shows) ---
              "XF86AudioRaiseVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg volume-up";
                };
              };
              "XF86AudioLowerVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg volume-down";
                };
              };
              "XF86AudioMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg volume-mute";
                };
              };
              "XF86AudioMicMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg mic-mute";
                };
              };

              "XF86MonBrightnessUp" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg brightness-up";
                };
              };
              "XF86MonBrightnessDown" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "noctalia msg brightness-down";
                };
              };

              "${MainMod}+O" = _: {
                props = {
                  repeat = false;
                };
                content = {
                  toggle-overview = _: { };
                };
              };
            };

            # Noctalia v5 recommended niri settings (from docs.noctalia.dev)
            extraConfig = /* kdl */ ''
              // Floating Noctalia settings window
              window-rule {
                match app-id="dev.noctalia.Noctalia"
                open-floating true
                default-column-width { fixed 1080; }
                default-window-height { fixed 920; }
              }

              // Allows notification actions and window activation from Noctalia
              debug {
                honor-xdg-activation-with-invalid-serial
              }

              // Blur behind Noctalia surfaces, sampling windows instead of the wallpaper
              layer-rule {
                match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
                background-effect {
                  xray false
                }
              }
            '';
          };
      };
    };
}
