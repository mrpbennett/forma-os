#!/bin/bash

gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'

# Reveal week numbers in the Gnome calendar
gsettings set org.gnome.desktop.calendar show-weekdate true

# Reveal weekday and set clock to 24h
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-format '24h'

# Turn off ambient sensors for setting screen brightness (they rarely work well!)
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.session idle-delay 300  # 5 minutes

# Configure Nautilus
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# Setting WorldClocks
gsettings set org.gnome.clocks world-clocks "[{'location': <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>}, {'location': <(uint32 2, <('Hong Kong', 'VHHH', true, [(0.38979019379430269, 1.9928751117510946)], [(0.38949931722116538, 1.9928751117510946)])>)>}, {'location': <(uint32 2, <('Los Angeles', 'KCQT', true, [(0.59370283970450188, -2.0644336110828618)], [(0.59432360095955872, -2.063741622941031)])>)>}]"
