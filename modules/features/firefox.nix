{ config, pkgs, ... }:
{
  flake.nixosModules.firefox = { lib, ... }: {
    programs.firefox = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        DontCheckDefaultBrowser = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = {
          #"*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        SearchEngines = {
          Default = "startpage";
          Remove = [ "Bing" ];
          Add = [
            {
              Name = "Startpage";
              URLTemplate = "https://www.startpage.com/search?q={searchTerms}";
              IconURL = "https://www.startpage.com/favicon.ico";
              Alias = "@sp";
            }
            {
              Name = "Nix Packages";
              URLTemplate = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
              IconURL = "https://nixos.wiki/favicon.png";
              Alias = "@np";
            }
            {
              Name = "NixOS Wiki";
              URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
              IconURL = "https://nixos.wiki/favicon.png";
              Alias = "@nw";
            }
          ];
        };

        # All preferences below are locked
        Preferences = lib.mapAttrs (_: Value: { inherit Value; Status = "locked"; }) {
          "browser.startup.page" = 3;
          "browser.startup.homepage_override.mstone" = "ignore";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.disableResetPrompt" = true;
          "browser.uitour.enabled" = false;
          "browser.zoom.siteSpecific" = true;
          "browser.tabs.firefox-view" = false;
          "browser.download.useDownloadDir" = false;
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.siteSettings" = false;
          "privacy.sanitize.sanitizeOnShutdown" = false;
          "signon.rememberSignons" = false;
          "passwordmanager.enabled" = false;
          "extensions.formautofill.address.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "browser.urlbar.autoFill" = true;
          "browser.urlbar.dnsFirstForSingleWords" = true;
          "browser.urlbar.suggest.history" = true;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.urlbar.suggest.openpage" = true;
          "browser.urlbar.suggest.searches" = false;
          "browser.search.suggest.enabled" = true;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
        };
      };
    };
  };
}
