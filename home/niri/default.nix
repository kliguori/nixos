{ ... }:
{
  home.file.".config/niri/config.kdl".text = ''
    // ~/.config/niri/config.kdl
   
    // No client decorations
    prefer-no-csd

    // Screenshots
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Inputs
    input {
      keyboard { 
        numlock
      }

      touchpad { 
        tap
        natural-scroll
      }

      focus-follows-mouse max-scroll-amount="0%"
    }
    
    // Monitors 
    /-output "eDP-1" {
      mode "1920x1080@120.030"
      scale 2
      transform "normal"
      // position x=... y=...   // only needed with multiple monitors
    }
   
    // Layouts
    layout {
      gaps 8
      center-focused-column "never"
      default-column-width { 
        proportion 0.5 
      }
    
      focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
      }
    
      border { 
        off 
      }
    }
   
   // Window rules
    window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
    }
    
    window-rule {
      geometry-corner-radius 8
      clip-to-geometry true
    }

    // Keybinds
    binds {
      // Core apps
      Mod+Return { spawn "kitty"; }
      Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Mod+Shift+L { spawn "dms" "ipc" "call" "lock" "lock"; }
    
      // Core actions
      Mod+Q repeat=false { close-window; }
      Mod+O repeat=false { toggle-overview; }
      Mod+Slash { show-hotkey-overlay; }
    
      // Focus 
      Mod+H { focus-column-left; }
      Mod+J { focus-window-or-workspace-down; }
      Mod+K { focus-window-or-workspace-up; }
      Mod+L { focus-column-right; }
    
      // Move (Mod+Space = grab)
      Mod+Alt+H { move-column-left; }
      Mod+Alt+J { move-window-down-or-to-workspace-down; }
      Mod+Alt+K { move-window-up-or-to-workspace-up; }
      Mod+Alt+L { move-column-right; }

      // Workspaces 
      Mod+U { focus-workspace-down; }
      Mod+I { focus-workspace-up; }
      Mod+Alt+U { move-column-to-workspace-down; }
      Mod+Alt+I { move-column-to-workspace-up; }
    
      // Workspaces 
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
    
      Mod+Alt+1 { move-column-to-workspace 1; }
      Mod+Alt+2 { move-column-to-workspace 2; }
      Mod+Alt+3 { move-column-to-workspace 3; }
      Mod+Alt+4 { move-column-to-workspace 4; }
      Mod+Alt+5 { move-column-to-workspace 5; }
      Mod+Alt+6 { move-column-to-workspace 6; }
      Mod+Alt+7 { move-column-to-workspace 7; }
      Mod+Alt+8 { move-column-to-workspace 8; }
      Mod+Alt+9 { move-column-to-workspace 9; }
    
      // Monitors (Ctrl = global)
      Ctrl+H { focus-monitor-left; }
      Ctrl+L { focus-monitor-right; }
      Ctrl+Alt+H { move-column-to-monitor-left; }
      Ctrl+Alt+L { move-column-to-monitor-right; }
    
      // Layout / state 
      Mod+R { switch-preset-column-width; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }
      Mod+V { toggle-window-floating; }
      Mod+C { center-column; }
    
      // Screenshots
      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Mod+Print { screenshot-window; }
    
      // Audio 
      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
    
      XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
      XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
      XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
      XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }
    
      // Brightness 
      XF86MonBrightnessUp   allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5"; }
    
      // Safety / misc
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+Shift+P { power-off-monitors; }   
      Ctrl+Alt+Delete { quit; }
    }
  '';
}
