{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.nix =
    { pkgs, ... }:
    {
      # some code editors need the LSP installed system wide like dis
      environment.systemPackages = with pkgs; [
        nil
        nixd
      ];

      nix = {
        settings = {
          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
            "https://notashelf.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6nCk48X65shshYpZqz0X9vRjayahF4GCednhgyXDYXk="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Bg="
            "notashelf.cachix.org-1:dnotJkHgUSMueuOQtLoFyic8xFqMqHa7953gJeAPRWk="
          ];

          # Set this to true to ensure Nix always checks for binaries first
          substitute = true;

          # slows down builds, use nix.optimise instead
          # auto-optimise-store = true;

          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        optimise = {
          automatic = true;
          dates = [ "03:45" ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };

      };

      boot.loader.systemd-boot.configurationLimit = 10;

      # nixpkgs configs
      nixpkgs.config.problems.handlers."gtk+".broken = "warn";

      nixpkgs.config = {
        allowUnfree = true;
      };
    };
}
