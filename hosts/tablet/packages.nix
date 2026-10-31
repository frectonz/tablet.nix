{ pkgs, ... }:
{
  environment.packages = [
    pkgs.git
    pkgs.iproute2
    pkgs.procps
    pkgs.rsync
    pkgs.vim
  ];
}
