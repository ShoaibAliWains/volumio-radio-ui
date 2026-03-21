#!/bin/bash
echo "Starting Custom Radio UI Setup..."

# Update system
sudo apt-get update

# Install HyperPixel 4.0 Drivers (Pimoroni official script)
echo "Installing Display Drivers..."
curl -sSL https://get.pimoroni.com/hyperpixel4 | bash

# Install dependencies for our custom UI
echo "Installing UI dependencies..."
sudo apt-get install -y python3-pip python3-flask chromium-browser openbox xinit

# Setup auto-start for the Kiosk UI
echo "Configuring Auto-boot..."
mkdir -p ~/.config/openbox
cat <<EOT > ~/.config/openbox/autostart
# Start the Python API in background
python3 $(pwd)/app.py &
# Start Chromium in Kiosk mode pointing to our UI
chromium-browser --kiosk --noerrdialogs --disable-infobars http://localhost:5000 &
EOT

# Setup bash profile to start X server automatically on boot
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' >> ~/.bash_profile

echo "Setup Complete! Please reboot the Raspberry Pi."
