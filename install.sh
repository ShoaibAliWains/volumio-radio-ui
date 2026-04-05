#!/bin/bash
echo "Starting Custom Radio UI Setup..."

# Update system
sudo apt-get update

# 1. Install WM8960 Audio HAT Drivers (Waveshare Official)
echo "Installing WM8960 Audio HAT Drivers..."
git clone https://github.com/waveshare/WM8960-Audio-HAT
cd WM8960-Audio-HAT
sudo ./install.sh
cd ..

# 2. Install HyperPixel 4.0 Drivers (Pimoroni official script)
echo "Installing Display Drivers..."
curl -sSL https://get.pimoroni.com/hyperpixel4 | bash

# 3. Install dependencies for our custom UI
echo "Installing UI dependencies..."
sudo apt-get install -y python3-pip python3-flask chromium-browser openbox xinit

# 4. Setup auto-start for the Kiosk UI
echo "Configuring Auto-boot..."
mkdir -p ~/.config/openbox
cat <<EOT > ~/.config/openbox/autostart
# Start the Python API in background
python3 $(pwd)/app.py &

# Wait a few seconds for server and Volumio to start
sleep 10

# Start Chromium in Kiosk mode strictly at 720x720
chromium-browser --kiosk --window-size=720,720 --window-position=0,0 --noerrdialogs --disable-infobars http://localhost:5000 &
EOT

# Setup bash profile to start X server automatically on boot
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' >> ~/.bash_profile

echo "Setup Complete! The Raspberry Pi will now reboot."
echo "Note: The audio HAT driver installation might take 5-10 minutes. Please be patient."
sudo reboot
