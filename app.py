from flask import Flask, render_template, request, jsonify
import json
import os

app = Flask(__name__)
STATIONS_FILE = 'stations.json'

# Load stations
def load_stations():
    if not os.path.exists(STATIONS_FILE):
        return []
    with open(STATIONS_FILE, 'r') as f:
        return json.load(f)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/stations', methods=['GET'])
def get_stations():
    return jsonify(load_stations())

@app.route('/add-station', methods=['POST'])
def add_station():
    data = request.json
    stations = load_stations()
    stations.append(data)
    with open(STATIONS_FILE, 'w') as f:
        json.dump(stations, f)
    return jsonify({"status": "success", "message": "Station added!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
