
<?php

$host = getenv('DSTORE_DB_HOST');
$dbname = getenv('DSTORE_DB_NAME');
$username = getenv('DSTORE_DB_USER');
$password = getenv('DSTORE_DB_PASSWORD');

try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password
    );

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    http_response_code(500);
    die(json_encode([
        'status' => 'error',
        'message' => 'Koneksi database gagal'
    ]));
}
