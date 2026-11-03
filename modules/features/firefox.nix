{ config, pkgs, ... }:
{
  flake.nixosModules.firefox = {
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

        # All locked preferences go here instead
        Preferences = {
          "browser.startup.page" = {
            Value = 3;
            Status = "locked";
          };
          "browser.startup.homepage_override.mstone" = {
            Value = "ignore";
            Status = "locked";
          };
          "trailhead.firstrun.didSeeAboutWelcome" = {
            Value = true;
            Status = "locked";
          };
          "browser.disableResetPrompt" = {
            Value = true;
            Status = "locked";
          };
          "browser.uitour.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.zoom.siteSpecific" = {
            Value = true;
            Status = "locked";
          };
          "browser.tabs.firefox-view" = {
            Value = false;
            Status = "locked";
          };
          "browser.download.useDownloadDir" = {
            Value = false;
            Status = "locked";
          };
          "privacy.trackingprotection.enabled" = {
            Value = true;
            Status = "locked";
          };
          "dom.security.https_only_mode" = {
            Value = true;
            Status = "locked";
          };
          "privacy.resistFingerprinting" = {
            Value = false;
            Status = "locked";
          };
          "network.cookie.lifetimePolicy" = {
            Value = 0;
            Status = "locked";
          };
          "privacy.clearOnShutdown.cookies" = {
            Value = false;
            Status = "locked";
          };
          "privacy.clearOnShutdown.siteSettings" = {
            Value = false;
            Status = "locked";
          };
          "privacy.sanitize.sanitizeOnShutdown" = {
            Value = false;
            Status = "locked";
          };
          "signon.rememberSignons" = {
            Value = false;
            Status = "locked";
          };
          "passwordmanager.enabled" = {
            Value = false;
            Status = "locked";
          };
          "extensions.formautofill.address.enabled" = {
            Value = false;
            Status = "locked";
          };
          "extensions.formautofill.creditCards.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.autoFill" = {
            Value = true;
            Status = "locked";
          };
          "browser.urlbar.dnsFirstForSingleWords" = {
            Value = true;
            Status = "locked";
          };
          "browser.urlbar.suggest.history" = {
            Value = true;
            Status = "locked";
          };
          "browser.urlbar.suggest.bookmark" = {
            Value = true;
            Status = "locked";
          };
          "browser.urlbar.suggest.openpage" = {
            Value = true;
            Status = "locked";
          };
          "browser.urlbar.suggest.searches" = {
            Value = false;
            Status = "locked";
          };
          "browser.search.suggest.enabled" = {
            Value = true;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.showSponsored" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = {
            Value = false;
            Status = "locked";
          };
          "browser.urlbar.suggest.quicksuggest.sponsored" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.feeds.system.topstories" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.feeds.topsites" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = {
            Value = false;
            Status = "locked";
          };
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = {
            Value = false;
            Status = "locked";
          };
          "app.shield.optoutstudies.enabled" = {
            Value = false;
            Status = "locked";
          };
          "browser.discovery.enabled" = {
            Value = false;
            Status = "locked";
          };
          "toolkit.telemetry.enabled" = {
            Value = false;
            Status = "locked";
          };
          "datareporting.healthreport.service.enabled" = {
            Value = false;
            Status = "locked";
          };
          "datareporting.healthreport.uploadEnabled" = {
            Value = false;
            Status = "locked";
          };
          "toolkit.telemetry.archive.enabled" = {
            Value = false;
            Status = "locked";
          };
        };
      };
    };
  };
}
