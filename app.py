from flask import Flask, render_template, request, jsonify
import json
import os
import subprocess

app = Flask(__name__)
CONFIG_FILE = 'config.json'
current_player = None # Background audio process ko track karne ke liye

# Auto-create & Load config file
def load_config():
    if not os.path.exists(CONFIG_FILE):
        default_config = {
            "station_name": "La Voix Divine",
            "stream_url": "http://162.244.81.219:8020/live",
            "volume": 80
        }
        with open(CONFIG_FILE, 'w') as f:
            json.dump(default_config, f)
        return default_config
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

# Main UI Route
@app.route('/')
def index():
    return render_template('index.html')

# Get current configuration
@app.route('/api/config', methods=['GET'])
def get_config():
    return jsonify(load_config())

# Play the stream using native Linux player (MPV)
@app.route('/api/play-stream', methods=['POST'])
def play_stream():
    global current_player
    config = load_config()
    
    # Check if frontend sent a custom URL
    data = request.get_json(silent=True)
    if data and 'url' in data:
        stream_url = data['url']
    else:
        stream_url = config.get("stream_url")
    
    try:
        # Puraana stream band karein agar koi chal raha hai
        if current_player:
            current_player.terminate()
            current_player.wait()

        # Naya stream play karein (Volumio ki bajaye MPV player use karein)
        current_player = subprocess.Popen(["mpv", "--no-video", stream_url])
        
        return jsonify({"status": "playing", "url": stream_url})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    # Run the server on all available network interfaces at port 5000
    app.run(host='0.0.0.0', port=5000)
