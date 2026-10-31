{
  config,
  flake,
  pkgs,
  ...
}:
let
  vars = import ./variables.nix;
  sshdDir = "${config.user.home}/sshd";

  sshdConfig = pkgs.writeText "sshd_config" ''
    Port ${toString vars.sshPort}
    HostKey ${sshdDir}/ssh_host_ed25519_key
    AuthorizedKeysFile ${flake}/users/frectonz/authorized_keys
    PasswordAuthentication no
    KbdInteractiveAuthentication no
    PermitRootLogin no
    StrictModes no
    PidFile ${sshdDir}/sshd.pid
    Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
  '';

  sshd-start = pkgs.writeShellScriptBin "sshd-start" ''
    echo "Starting sshd on port ${toString vars.sshPort} (Ctrl-C to stop)"
    exec ${pkgs.openssh}/bin/sshd -f ${sshdConfig} -D -e "$@"
  '';
in
{
  environment.packages = [
    pkgs.openssh
    sshd-start
  ];

  build.activation.sshd = ''
    if [ ! -e "${sshdDir}/ssh_host_ed25519_key" ]; then
      $VERBOSE_ECHO "Generating sshd host key in ${sshdDir}"
      $DRY_RUN_CMD mkdir -p "${sshdDir}"
      $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f "${sshdDir}/ssh_host_ed25519_key"
    fi
  '';
}
