
<?php
$serverName = gethostname();
$phpVersion = PHP_VERSION;
?>

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
            margin: 0;
            padding: 40px 20px;
        }
        .container {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 4px 15px #0001;
        }
        h1 { color: #2563eb; }
        .status {
            background: #dcfce7;
            color: #166534;
            padding: 12px;
            border-radius: 8px;
        }
        li { margin: 12px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Docker Web Development</h1>

        <p class="status">
            PHP berhasil dijalankan melalui Docker!
        </p>

        <h2>Informasi Server</h2>
        <ul>
            <li>Service: PHP Apache</li>
            <li>Versi PHP: <?= htmlspecialchars($phpVersion) ?></li>
            <li>Hostname container:
                <?= htmlspecialchars($serverName) ?>
            </li>
        </ul>

        <h2>Service dalam Environment</h2>
        <ul>
            <li>Frontend: Node.js</li>
            <li>Backend: PHP dan Python FastAPI</li>
            <li>Database SQL: MySQL dan PostgreSQL</li>
            <li>Database NoSQL: MongoDB</li>
            <li>Messaging: MQTT dan RabbitMQ</li>
            <li>Real-time communication: WebSocket</li>
        </ul>
    </div>
</body>
</html>
