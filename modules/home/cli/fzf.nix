{
  config,
  lib,
  host,
  unstable,
  ...
}: let
  accent = "#" + config.lib.stylix.colors.base0D;
  foreground = "#" + config.lib.stylix.colors.base05;
  muted = "#" + config.lib.stylix.colors.base03;

  barChoice = (import ../../../hosts/${host}/variables.nix).barChoice;
in {
  programs.fzf = lib.mkMerge [
    {
      enable = true;
      package = unstable.fzf;
      enableZshIntegration = true;
    }

    (lib.mkIf (barChoice == "hyprland") {
      colors = {
        "fg+" = accent;
        "bg+" = "-1";
        "fg" = foreground;
        "bg" = "-1";
        "prompt" = muted;
        "pointer" = accent;
      };

      defaultOptions = [
        "--margin=1"
        "--layout=reverse"
        "--border=none"
        "--info=hidden"
        "--header="
        "--prompt=/ "
        "-i"
        "--no-bold"
        "--bind=enter:execute(nvim {})"
        "--preview=bat --style=numbers --color=always --line-range :500 {}"
        "--preview-window=right:60%:wrap"
      ];
    })
  ];
}
