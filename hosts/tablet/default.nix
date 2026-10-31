{ flake, inputs, ... }:
{
  class = "nix-on-droid";

  value = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    modules = [ ./configuration.nix ];

    extraSpecialArgs = { inherit flake inputs; };

    pkgs = import inputs.nixpkgs {
      system = "aarch64-linux";
      overlays = [ inputs.nix-on-droid.overlays.default ];
    };

    home-manager-path = inputs.home-manager.outPath;
  };
}
