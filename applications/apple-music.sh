#!/bin/bash

cat <<EOF >~/.local/share/applications/AppleMusic.desktop
[Desktop Entry]
Version=1.0
Name=Apple Music
Comment=Apple Music
Exec=google-chrome --password-store=basic --app="https://music.apple.com/gb/home" --name=AppleMusic --class=AppleMusic
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/forma/applications/icons/AppleMusic.png
Categories=GTK;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF
