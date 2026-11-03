{ self, inputs, ... }: {
  flake.nixosModules.ansibleopenstack =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      openstackEnv = pkgs.python3.withPackages (
        ps: with ps; [
          openstacksdk
          ansible
          ansible-core
          python-openstackclient
        ]
      );
    in
    {
      environment.systemPackages = [ openstackEnv ];
    };
}
