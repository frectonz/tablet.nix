{ pkgs, ... }:
let
  vars = import ./hosts/tablet/variables.nix;
  target = "${vars.user}@${vars.address}";
  sshOpts = "-p ${toString vars.sshPort}";

  tablet-login = pkgs.writeShellApplication {
    name = "tablet-login";
    runtimeInputs = [ pkgs.openssh ];
    text = ''
      ssh ${sshOpts} ${target} "$@"
    '';
  };

  tablet-switch = pkgs.writeShellApplication {
    name = "tablet-switch";
    runtimeInputs = [
      pkgs.openssh
      pkgs.rsync
    ];
    text = ''
      rsync -az --delete --exclude .direnv --exclude result \
        -e "ssh ${sshOpts}" ./ ${target}:tablet.nix/
      ssh ${sshOpts} ${target} \
        'nix-on-droid switch --flake "$HOME/tablet.nix#tablet"' "$@"
    '';
  };
in
pkgs.mkShellNoCC {
  packages = [
    tablet-login
    tablet-switch
  ];
}
