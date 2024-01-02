#!/usr/bin/env python3
from flask import Flask
import os
import random
import time

app = Flask(__name__)

def try_connect(locations):
    while True:
        random.shuffle(locations)
        for location in locations:
            # Execute the NordVPN connect command with the selected location
            result = os.system(f"nordvpn connect {location}")
            if result == 0:
                return location
            time.sleep(5)  # Delay for 5 seconds before the next attempt

@app.route('/reconnect')
def reconnect():
    # List of NordVPN server locations
    locations = ['lu', 'be', 'nl', 'dk', 'cz', 'hu']

    connected_location = try_connect(locations)
    return f"Reconnect command successfully sent to NordVPN for location: {connected_location}", 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
