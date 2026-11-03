{self, inputs, ...}: {
	flake.nixosConfigurations.t14s-machine = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.t14s-machine-configuration
		];
	};
}
