{ self, inputs, ... }:
{
  flake.nixosModules.t14s-machine-configuration =
    {
      pkgs,
      lib,
      config,
      self',
      ...
    }:
    {
      imports = [
        # --- Hardware and Inputs ---
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
        self.nixosModules.t14s-machine-hardware
        inputs.noctalia-greeter.nixosModules.default

        # --- Modular System Profiles ---
        self.nixosModules.desktop
        self.nixosModules.nix
        self.nixosModules.core
        self.nixosModules.base
        self.nixosModules.gaming
        self.nixosModules.power

        # --- Shells & Ecosystem Environments ---
        self.nixosModules.noctalia
      ];

      # --- Environment & System Packages ---
      environment.systemPackages = with pkgs; [
        # Utilities
        vim
        age
        ripgrep
        jq
        dig
        yt-dlp
        networkmanagerapplet
        nautilus

        # Tools
        claude-code

        # Formatters
        nixfmt
        black

        # Applications
        mpv
        vesktop
        image-roll

      ];

      # --- User Configuration ---
      preferences.user.name = "crux";

      users.users."${config.preferences.user.name}" = {
        isNormalUser = true;
        description = config.preferences.user.name;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "input"
          "bluetooth"
        ];
        hashedPassword = "$6$0sfQ8ixqLcqKfVzn$Bd7MrgBF67TKtyxKtOamW6KSZ87S0hi1W2D2gyR6w.CdsInDPAagTXAn7R2eCm7jd/mHdvE8l9k5W2JM55DxM0";
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment;
      };

      # --- Networking & Localization ---
      networking.hostName = "t14s-machine";

      time.timeZone = "Europe/Stockholm";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = [
          "en_US.UTF-8/UTF-8"
          "sv_SE.UTF-8/UTF-8"
        ];
        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
      };

      # --- Boot & Kernel Configuration ---
      boot = {
        plymouth.enable = true;
        tmp.useTmpfs = true;
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
      };

      # --- Graphical System & Display Manager ---
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

      services.xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };

      # --- Hardware Optimization ---
      powerManagement.enable = true;
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # --- System Deployment State ---
      system.stateVersion = "25.11";
    };
}
