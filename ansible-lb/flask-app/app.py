from flask import Flask
import socket
import subprocess

app = Flask(__name__)

app_servers = {
    "vm-1": "192.168.1.5",
    "vm-2": "192.168.1.6",
    "vm-3": "192.168.1.7",
    "vm-4": "192.168.1.8",
    "vm-5": "192.168.1.9"
}

def ping(ip):
    try:
        subprocess.check_output(["ping", "-c", "1", "-W", "1", ip])
        return "✅ Online"
    except subprocess.CalledProcessError:
        return "❌ Offline"

@app.route('/')
def home():
    hostname = socket.gethostname()
    report = [f"{name} ({ip}): {ping(ip)}" for name, ip in app_servers.items()]
    return f"<h3>This response came from: {hostname}</h3><br>" + "<br>".join(report)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
