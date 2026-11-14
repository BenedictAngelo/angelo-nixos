{
  config,
  inputs,
  self,
  pkgs,
  ...
}: let
  path = "~/angelo-nixos/wallpapers/";
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      # This may also be a string or path to a .toml file.
      launch_apps_as_systemd_services = true;
      theme = {
        mode = "auto";
        source = "wallpaper";
        #builtin = "Catppuccin";
        wallpaper_scheme = "m3-tonal-spot";
      };
      wallpaper = {
        enabled = true;
        directory = path;
        #directory_light = path_light;
        #directory_dark = path_dark;
        default = {
          path = path + "/2b.jpg";
        };
      };
      location = {
        auto_locate = true;
        sunset = "20:30";
        sunrise = "07:30";
      };
    };
  };
  xdg.configFile."niri/others.kdl".text = ''

    spawn-at-startup "noctalia"

    binds {

        Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
        Mod+N { spawn-sh "noctalia msg panel-toggle notifications"; }
        Mod+Shift+N { spawn-sh "noctalia msg settings-toggle"; }
        Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }

        XF86AudioRaiseVolume { spawn-sh "noctalia msg volume-up"; }
        XF86AudioLowerVolume { spawn-sh "noctalia msg volume-down"; }
        XF86AudioMute { spawn-sh "noctalia msg volume-mute"; }

        XF86MonBrightnessUp { spawn-sh "noctalia msg brightness-up"; }
        XF86MonBrightnessDown { spawn-sh "noctalia msg brightness-down"; }

        Print                 { spawn-sh "noctalia msg screenshot-region"; }
        Ctrl+Print           { spawn-sh "noctalia msg screenshot-fullscreen"; }
        Shift+Print          { spawn-sh "noctalia msg screenshot-fullscreen pick"; }
        Ctrl+Shift+Print     { spawn-sh "noctalia msg screenshot-fullscreen all"; }
    }


    include "noctalia.kdl"
  '';
}
