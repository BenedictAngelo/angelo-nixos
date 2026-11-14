{
  config,
  pkgs,
  ...
}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        source = "nixos";
        type = "builtin";
        height = 16;
        padding = {
          top = 0;
          left = 1;
        };
      };

      display = {
        separator = " ";
      };

      modules = [
        {
          type = "custom";
          #format = "\u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m";
          #format = "\x1b[90m  \x1b[31m  \x1b[32m  \x1b[33m  \x1b[34m  \x1b[35m  \x1b[36m  \x1b[37m";
          #format = "              ";
          format = "╭────────────────────────────────────────────╮";
        }

        "break"

        {
          type = "title";
          key = "  󰟀 ";
        }

        "break"

        {
          type = "os";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "kernel";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "shell";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "terminal";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "terminalfont";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "wm";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "display";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "cpu";
          format = "{1}";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "gpu";
          format = "{2}";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "disk";
          key = "   ";
          keyColor = "34";
        }
        {
          type = "uptime";
          key = "   ";
          keyColor = "34";
        }

        {
          type = "command";
          key = "  󱦟 ";
          keyColor = "34";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }

        "break"

        {
          type = "custom";
          #format = "\u001b[90m  \u001b[31m  \u001b[32m  \u001b[33m  \u001b[34m  \u001b[35m  \u001b[36m  \u001b[37m";
          #format = "\x1b[90m  \x1b[31m  \x1b[32m  \x1b[33m  \x1b[34m  \x1b[35m  \x1b[36m  \x1b[37m";
          #format = "              ";
          format = "╰────────────────────────────────────────────╯";
        }

        "break"
      ];
    };
  };
}
