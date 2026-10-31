{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./packages.nix
    ./sshd.nix
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "24.05";
}
