#!/bin/bash

echo "⚠️ This will remove XFCE and Mint apps, then install Sway + your toolset. Continue? (Ctrl+C to cancel)"
read -p "Press Enter to continue..."

# === REMOVE XFCE + BLOAT ===
sudo apt purge -y '^xfce4.*' '^xfdesktop.*' '^xfwm4.*' lightdm slick-greeter mint-meta-xfce

sudo apt purge -y \
  libreoffice-* \
  thunderbird \
  hexchat \
  hypnotix \
  pix \
  drawing \
  celluloid \
  simple-scan \
  transmission-gtk \
  warpinator \
  webapp-manager \
  gnome-calendar \
  onboard

sudo apt autoremove --purge -y
sudo apt clean

# === INSTALL PACKAGES ===
sudo apt update
sudo apt install -y \
  xserver-xorg \
  xinit \
  dbus-x11 \
  sway \
  waybar \
  rofi \
  firefox \
  kitty \
  zsh \
  starship \
  eza \
  man-db \
  curl \
  git \
  network-manager-gnome

# === SET DEFAULT SHELL TO ZSH ===
chsh -s /usr/bin/zsh "$USER"

# === SETUP nm-applet AS USER SERVICE ===
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/nm-applet.service <<EOF
[Unit]
Description=NetworkManager Applet
After=graphical-session.target

[Service]
ExecStart=/usr/bin/nm-applet
Restart=on-failure

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now nm-applet.service

echo "✅ Done! XFCE removed, Sway + Kitty + Waybar + Networking installed."
echo "🔁 Reboot, log in via TTY, and type: sway"
