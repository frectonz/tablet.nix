{ config, ... }:
{
  home.stateVersion = "26.11";

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . "${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix-on-droid-session-init.sh"
    '';
    initExtra = ''
      if [[ -z "$__TABLET_NU" ]]; then
        export __TABLET_NU=1
        exec nu
      fi
    '';
  };

  programs.nushell = {
    enable = true;
    settings.show_banner = false;
  };
}
