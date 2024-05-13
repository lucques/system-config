# Returns: i3 config string

pkgs:
screenLayouts:

let
    mod = "Mod4";
    floating_modifier = "Mod4";
in

{
    ".config/i3/config" = [
        {
            order = 1;
            content = ''
                ###########
                # General #
                ###########

                font pango:Pango, monospace 10.000000
                floating_modifier ${floating_modifier}
                default_border normal 2
                default_floating_border normal 2
                hide_edge_borders none
                focus_wrapping yes
                focus_follows_mouse yes
                focus_on_window_activation smart
                mouse_warping output
                workspace_layout default
                workspace_auto_back_and_forth yes
                client.focused #4c7899 #285577 #ffffff #2e9ef4 #285577
                client.focused_inactive #333333 #5f676a #ffffff #484e50 #5f676a
                client.unfocused #333333 #222222 #888888 #292d2e #222222
                client.urgent #2f343a #900000 #ffffff #900000 #900000
                client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
                client.background #ffffff


                ########################
                # Keybindings: General #
                ########################

                # Kill focused window
                bindsym ${mod}+q kill

                # Start dmenu
                bindsym ${mod}+d exec dmenu_run

                # Change focus
                bindsym ${mod}+Left focus left
                bindsym ${mod}+Down focus down
                bindsym ${mod}+Up focus up
                bindsym ${mod}+Right focus right

                # Move focused window
                bindsym ${mod}+Shift+Left move left
                bindsym ${mod}+Shift+Down move down
                bindsym ${mod}+Shift+Up move up
                bindsym ${mod}+Shift+Right move right

                # Move workspace
                bindsym ${mod}+Ctrl+Shift+Down move workspace to output down
                bindsym ${mod}+Ctrl+Shift+Left move workspace to output left
                bindsym ${mod}+Ctrl+Shift+Right move workspace to output right
                bindsym ${mod}+Ctrl+Shift+Up move workspace to output up

                # Change container layout
                bindsym ${mod}+s layout stacking
                bindsym ${mod}+w layout tabbed
                bindsym ${mod}+e layout toggle split

                # Split container layout
                bindsym ${mod}+Shift+s split toggle; layout stacking
                bindsym ${mod}+Shift+w split toggle; layout tabbed
                bindsym ${mod}+Shift+e split toggle

                # TODO: The following 2 needed?
                # jump to urgent window
                # "${mod}+x [urgent=latest] focus

                # enter fullscreen mode for the focused container
                # "${mod}+F11 fullscreen toggle

                # Change focus between tiling / floating windows
                bindsym ${mod}+space focus mode_toggle

                # Toggle tiling / floating
                bindsym ${mod}+Shift+space floating toggle

                # Focus the parent/child container
                bindsym ${mod}+Next focus child
                bindsym ${mod}+Prior focus parent

                # Move the currently focused window to the scratchpad
                bindsym ${mod}+Shift+minus move scratchpad

                # Show the next scratchpad window or hide the focused scratchpad window.
                # If there are multiple scratchpad windows, this command cycles through them.
                bindsym ${mod}+minus scratchpad show

                # Switch to workspace
                bindsym ${mod}+1 workspace "10:1"
                bindsym ${mod}+2 workspace "20:2"
                bindsym ${mod}+3 workspace "30:3"
                bindsym ${mod}+4 workspace "40:4"
                bindsym ${mod}+5 workspace "50:5"
                bindsym ${mod}+6 workspace "60:6"
                bindsym ${mod}+7 workspace "70:7"
                bindsym ${mod}+8 workspace "80:8"
                bindsym ${mod}+9 workspace "90:9"
                bindsym ${mod}+0 workspace "100:10"

                # Move focused container to workspace
                bindsym ${mod}+Shift+1 move container to workspace "10:1"
                bindsym ${mod}+Shift+2 move container to workspace "20:2"
                bindsym ${mod}+Shift+3 move container to workspace "30:3"
                bindsym ${mod}+Shift+4 move container to workspace "40:4"
                bindsym ${mod}+Shift+5 move container to workspace "50:5"
                bindsym ${mod}+Shift+6 move container to workspace "60:6"
                bindsym ${mod}+Shift+7 move container to workspace "70:7"
                bindsym ${mod}+Shift+8 move container to workspace "80:8"
                bindsym ${mod}+Shift+9 move container to workspace "90:9"
                bindsym ${mod}+Shift+0 move container to workspace "100:10"

                # Restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
                bindsym ${mod}+Shift+r restart

                # Enter "resize" mode
                bindsym ${mod}+r mode "resize"


                #######################################
                # Keybindings: Audio & Screen Control #
                #######################################

                # The following prints all Pulseaudio sinks line-wise:
                #   pactl list short sinks | awk '{print $1}'
                # The following is executed for each line of input pactl command
                #   xargs -I {} sh -c 'pactl set-sink-volume {} -5%'

                # Mute sound
                bindsym XF86AudioMute exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-mute {} toggle'
                bindsym ${mod}+F1     exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-mute {} toggle'

                # Decrease sound volume
                bindsym XF86AudioLowerVolume exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} -5%'
                bindsym ${mod}+F2            exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} -5%'

                # Increase sound volume
                bindsym XF86AudioRaiseVolume exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} +5%'
                bindsym ${mod}+F3            exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} +5%'

                # Screen brightness control
                bindsym XF86MonBrightnessDown exec brightnessctl s 20%-
                bindsym ${mod}+F5             exec brightnessctl s 20%-
                bindsym XF86MonBrightnessUp   exec brightnessctl s +20%
                bindsym ${mod}+F6             exec brightnessctl s +20%
                bindsym XF86Display           exec ${pkgs.lukestools}/bin/backlight-toggle
                bindsym ${mod}+F7             exec ${pkgs.lukestools}/bin/backlight-toggle

                # Change screen layout
                bindsym ${mod}+F9  exec ${screenLayouts.standalone}
                bindsym ${mod}+F10 exec ${screenLayouts.homeSingle}
                bindsym ${mod}+F11 exec ${screenLayouts.homeDouble}
                bindsym ${mod}+F12 exec ${screenLayouts.school}


                ########
                # Apps #
                ########

                # Firefox
                bindsym ${mod}+f       workspace "103:f"
                bindsym ${mod}+Shift+f move container to workspace "103:f"
                assign [class="firefox"] "103:f"

                # Screen capture
                bindsym ${mod}+F8 exec flameshot gui

                # Terminal
                bindsym ${mod}+Return exec i3-sensible-terminal

                # Thunar
                bindsym ${mod}+z exec ${pkgs.lukestools}/bin/i3-thunar-toggle


                #########
                # Modes #
                #########

                mode "resize" {
                    bindsym h resize shrink width 10 px or 10 ppt
                    bindsym j resize grow height 10 px or 10 ppt
                    bindsym k resize shrink height 10 px or 10 ppt
                    bindsym l resize grow width 10 px or 10 ppt
                    bindsym Shift+h resize shrink width 50 px or 50 ppt
                    bindsym Shift+j resize grow height 50 px or 50 ppt
                    bindsym Shift+k resize shrink height 50 px or 50 ppt
                    bindsym Shift+l resize grow width 50 px or 50 ppt

                    # Same bindings, but for the arrow keys
                    bindsym Left resize shrink width 10 px or 10 ppt
                    bindsym Down resize grow height 10 px or 10 ppt
                    bindsym Up resize shrink height 10 px or 10 ppt
                    bindsym Right resize grow width 10 px or 10 ppt

                    # Back to normal: Enter or Escape
                    bindsym Return mode default
                    bindsym Escape mode default
                }


                ########
                # Bars #
                ########

                bar {
                    position bottom

                    workspace_buttons yes
                    strip_workspace_numbers yes

                    font pango:Pango, monospace 10.000000
                    
                    status_command i3status
                    i3bar_command i3bar
                }


                ################
                # Startup apps #
                ################

                # Screen layout
                exec --no-startup-id ${screenLayouts.standalone}

                # Low-battery warning
                exec --no-startup-id ${pkgs.i3-battery-popup}/i3-battery-popup -n -s ${pkgs.i3-battery-popup}/i3-battery-popup.wav

                # Autokey
                exec --no-startup-id autokey
            '';
        }
    ];
    ".config/i3status/config" = [
        {
            order = 1;
            content = ''
                general {
                    colors = true
                    color_good = "#81a380"
                    color_degraded = "#000000"
                    color_bad = "#e25f6c"
                    interval = 5
                }

                order += "ipv6"
                order += "disk /"
                order += "wireless _first_"
                order += "ethernet _first_"
                order += "battery all"
                order += "load"
                order += "tztime local"
                order += "volume master"

                wireless _first_ {
                    format_up = "W: (%quality at %essid) %ip"
                    format_down = "W: down"

                }

                ethernet _first_ {
                    # if you use %speed, i3status requires root privileges
                    format_up = "E: %ip (%speed)"
                    format_down = "E: down"
                }

                battery all {
                    format = "  %status %percentage %remaining  "
                    format_down = "No battery"
                    status_chr = "CHR"
                    status_bat = "BAT"
                    status_unk = "UNK"
                    status_full = "FULL"
                }

                tztime local {
                    format = "  %d.%m.  %H:%M  "
                }

                load {
                    format = "  %1min  "
                }

                disk "/" {
                    format = "%avail"
                }

                volume master {
                    format = "  ♪ %volume"
                    format_muted = "  ♪ %volume"
                    device = "default"
                    mixer = "Master"
                    mixer_idx = 0
                    color_degraded = "#FF0000"
                }
            '';
        }
    ];
}