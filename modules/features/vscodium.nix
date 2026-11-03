{ ... }:
{
  flake.nixosModules.vscodium =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions; [
            jdinhlife.gruvbox
            jnoortheen.nix-ide
            mkhl.direnv
            redhat.vscode-yaml
            redhat.ansible
            hashicorp.terraform
            timonwong.shellcheck
          ];
        })

        nixd
        nixfmt
        shellcheck
      ];
    };
}
