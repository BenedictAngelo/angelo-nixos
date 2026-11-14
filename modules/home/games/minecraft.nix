{pkgs, ...}: {
  home.packages = [
    pkgs.jdk25
    pkgs.prismlauncher
  ];
}
