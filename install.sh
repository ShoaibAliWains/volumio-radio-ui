#!/bin/bash
echo "Starting Custom Radio UI Setup..."

# Update system
sudo apt-get update

# 1. Install WM8960 Audio HAT Drivers
echo "Installing WM8960 Audio HAT Drivers..."
git clone https://github.com/waveshare/WM8960-Audio-HAT
cd WM8960-Audio-HAT
sudo ./install.sh
cd ..

# 2. Install Dependencies for Web-Based UI
echo "Installing UI dependencies (Chromium and Flask)..."
sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox python3-pip chromium-browser -y
sudo pip3 install flask --break-system-packages

# 3. Enable Auto-Login
echo "Enabling Auto-Login..."
sudo raspi-config nonint do_boot_behaviour B2

# 4. Setup auto-start for Chromium and Flask App
echo "Configuring Auto-boot..."
mkdir -p ~/.config/openbox

cat <<EOT > ~/.config/openbox/autostart
# Navigate to the project folder
cd /home/pi/volumio-radio-ui

# Start the Flask web server
python3 app.py &

# Wait for the server to initialize
sleep 5

# Start Chromium in Kiosk mode
chromium-browser --kiosk --window-size=720,720 --window-position=0,0 --noerrdialogs --disable-infobars http://localhost:5000 &
EOT

# Setup bash profile to start X server automatically on boot
touch ~/.bash_profile
if ! grep -q "startx" ~/.bash_profile; then
    echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' >> ~/.bash_profile
fi

# 5. Install HyperPixel 4.0 Drivers (Legacy branch - Keep this as client confirmed it worked for their hardware)
echo "Installing Display Drivers..."
curl -sSL https://get.pimoroni.com/hyperpixel4-legacy | bash

echo "Setup Complete! Type 'sudo reboot' if it doesn't reboot automatically."
