
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from datetime import datetime

app = FastAPI(
    title="Docker Web Development API",
    description="API Python dan WebSocket untuk tugas Docker Compose",
    version="1.0.0"
)


@app.get("/")
def home():
    return {
        "message": "Python FastAPI berhasil berjalan di Docker!",
        "service": "Python API",
        "status": "running",
        "time": datetime.now().isoformat()
    }


@app.get("/api/status")
def status():
    return {
        "frontend": "Node.js",
        "backend": "Python FastAPI",
        "websocket": "available",
        "status": "running"
    }


@app.get("/api/hello")
def hello():
    return {
        "message": "Halo! Ini respons dari API Python.",
        "success": True
    }


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            message = await websocket.receive_text()

            await websocket.send_text(
                f"Pesan diterima server: {message}"
            )

    except WebSocketDisconnect:
        print("Klien WebSocket terputus")
