
const http = require("http");

const PORT = 3000;

const html = `
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Web Development</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
            padding: 40px 20px;
        }
        main {
            max-width: 750px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0001;
        }
        h1 { color: #16a34a; }
        .status {
            padding: 12px;
            background: #dcfce7;
            color: #166534;
            border-radius: 8px;
        }
        li { margin: 12px 0; }
        a { color: #2563eb; }
    </style>
</head>
<body>
    <main>
        <h1>Docker Web Development</h1>
        <p class="status">Node.js frontend berhasil berjalan!</p>

        <h2>Service Environment</h2>
        <ul>
            <li>Frontend: Node.js</li>
            <li>Backend: PHP Apache dan Python FastAPI</li>
            <li>SQL: MySQL dan PostgreSQL</li>
            <li>NoSQL: MongoDB</li>
            <li>Messaging: MQTT dan RabbitMQ</li>
            <li>Real-time: WebSocket</li>
        </ul>

        <h2>Pengujian Service</h2>
        <ul>
            <li><a href="http://localhost:8080">Buka halaman PHP</a></li>
            <li><a href="http://localhost:8000/docs">Buka Python API</a></li>
            <li><a href="http://localhost:8081">Buka phpMyAdmin</a></li>
            <li><a href="http://localhost:5050">Buka pgAdmin</a></li>
            <li><a href="http://localhost:8082">Buka Mongo Express</a></li>
            <li><a href="http://localhost:15672">Buka RabbitMQ</a></li>
        </ul>
    </main>
</body>
</html>
`;

const server = http.createServer((req, res) => {
    if (req.url === "/api/status") {
        res.writeHead(200, {
            "Content-Type": "application/json"
        });

        res.end(JSON.stringify({
            service: "Node.js",
            status: "running"
        }));
        return;
    }

    res.writeHead(200, {
        "Content-Type": "text/html; charset=utf-8"
    });

    res.end(html);
});

server.listen(PORT, "0.0.0.0", () => {
    console.log(`Frontend berjalan pada port ${PORT}`);
});
