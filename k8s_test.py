import json
import time
import os

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'



def monitor_app(use_reloader=True, port=10000):
    app.run(host="0.0.0.0", port=port, threaded=True, use_reloader=use_reloader)


if __name__ == "__main__":
    monitor_app()