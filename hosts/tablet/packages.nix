{ pkgs, ... }:
{
  environment.packages = [
    pkgs.git
    pkgs.gnutar
    pkgs.iproute2
    pkgs.procps
    pkgs.vim
  ];
}
