{
  config,
  inputs,
  host,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix;
  inherit
    (vars)
    shellChoice
    barChoice
    browser
    terminalChoice
    niriMonitorSettings
    ;
in {
  xdg.configFile."niri/config.kdl".text = ''

    input {
        keyboard {
            xkb {
                layout "us"
            }
            numlock
            repeat-delay 300
            repeat-rate 35
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }

    }
    prefer-no-csd

    ${niriMonitorSettings}

    layout {
        gaps 4
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33
            proportion 0.5
            proportion 0.66
        }

        default-column-width { proportion 0.5; }

        focus-ring {

            width 2
            active-color "#7fc8ff"
            inactive-color "#505050"
        }

        border {
            off
        }

        shadow {
            softness 25
            spread 5
            offset x=0 y=5
            color "#0007"
        }
    }

    animations {
        slowdown 1.0
    }


    hotkey-overlay {
      skip-at-startup
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    window-rule {
        geometry-corner-radius 6
        clip-to-geometry true
    }


    window-rule {
        match is-active=false
        opacity 0.75
        background-effect {
            blur true
            xray true
        }
    }
    blur {

        passes 4
        offset 3.0
        noise 0.04
        saturation 1.3
    }

    debug {
        honor-xdg-activation-with-invalid-serial
    }

    layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
    }

    binds {
        Mod+Return { spawn "${terminalChoice}"; }
        Mod+B { spawn "${browser}"; }
        Mod+E { spawn "${terminalChoice}" "-e" "${shellChoice}" "-c" "yazi"; }
        Mod+C { spawn "${terminalChoice}" "-e" "${shellChoice}" "-c" "nvim"; }
        Mod+Shift+C { spawn "zeditor" ; }
        Mod+Shift+E { spawn "thunar" ; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }

        Mod+Q { close-window; }
        Mod+Shift+T { toggle-window-floating; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }

        Mod+W { toggle-column-tabbed-display; }
        Mod+Tab { toggle-overview; }

        Mod+F { maximize-column; }
        Mod+M { maximize-window-to-edges; }

        Mod+R { switch-preset-column-width; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+Shift+F { fullscreen-window; }
      }

    include "others.kdl"
  '';
}
