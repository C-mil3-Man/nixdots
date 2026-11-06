{
  flake.nixosModules.apps-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        age
        ripgrep
        jq
        dig
      ];
    };

  flake.nixosModules.apps-media =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mpv
        image-roll
        yt-dlp
      ];
    };

  flake.nixosModules.apps-social =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ vesktop ];
    };

  flake.nixosModules.apps-dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
        nixfmt
        black
      ];
    };
}
