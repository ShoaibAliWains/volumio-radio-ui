# Custom Touchscreen Radio UI 📻

A sleek, lightweight web-based frontend and automated setup script for running a Custom Radio UI. Designed specifically for the Raspberry Pi Zero 2 W using a pure headless Linux environment (No heavy OS required).

## 🛠️ Hardware Requirements
- Raspberry Pi Zero 2 W
- Pimoroni HyperPixel 4.0 (Square) Touchscreen
- Waveshare WM8960 Audio HAT
- MicroSD Card (8GB+)

## ✨ Features
- **Lightweight Core:** Runs on pure Raspberry Pi OS Lite (32-bit). No heavy Volumio or desktop environments needed.
- **Native Audio Engine:** Uses Linux's highly efficient `mpv` player to handle live internet streams directly through the Audio HAT without buffering.
- **Custom Square UI:** A modern interface perfectly scaled for the 720x720 HyperPixel display, powered by Flask and standard web technologies.
- **Kiosk Auto-Boot:** Bypasses login prompts and boots directly into a full-screen Chromium kiosk mode for a seamless appliance experience.
- **Hardware Sync:** On-screen volume controls directly manipulate the physical ALSA mixer of the Audio HAT.

---

## 🚀 Installation Guide

### Step 1: Base OS Setup
We do **not** use Volumio for this setup. 
1. Flash **Raspberry Pi OS Lite (32-bit)** onto your MicroSD card using the official Raspberry Pi Imager.
2. In the Imager settings, ensure you set your hostname, enable SSH, and pre-configure your Wi-Fi credentials.
3. Insert the SD card, attach your HAT and Screen, and power on the device.

### Step 2: The 1-Click Installer
Connect to your Raspberry Pi via SSH from your computer and run this single command to install all hardware drivers, UI dependencies, and configure the auto-boot sequence:

```bash
git clone [https://github.com/ShoaibAliWains/volumio-radio-ui.git](https://github.com/ShoaibAliWains/volumio-radio-ui.git) && cd volumio-radio-ui && bash install.sh

Note: The script takes about 5-10 minutes to compile audio drivers and install browser dependencies. The system will automatically reboot into the UI once finished.
