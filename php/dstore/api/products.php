<?php

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];

try {

    if ($method === 'GET') {

        if (isset($_GET['id'])) {
            $stmt = $pdo->prepare(
                "SELECT * FROM products WHERE id = ?"
            );
            $stmt->execute([$_GET['id']]);

            $product = $stmt->fetch();

            echo json_encode($product ?: [
                'message' => 'Produk tidak ditemukan'
            ]);

        } else {
            $stmt = $pdo->query(
                "SELECT * FROM products ORDER BY id DESC"
            );

            echo json_encode($stmt->fetchAll());
        }

    } elseif ($method === 'POST') {

        $data = json_decode(file_get_contents('php://input'), true);

        $sql = "INSERT INTO products
                (title, description, category, price, stock, brand, thumbnail)
                VALUES (?, ?, ?, ?, ?, ?, ?)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $data['title'],
            $data['description'] ?? '',
            $data['category'] ?? '',
            $data['price'],
            $data['stock'] ?? 0,
            $data['brand'] ?? '',
            $data['thumbnail'] ?? ''
        ]);

        echo json_encode([
            'message' => 'Produk berhasil ditambahkan',
            'id' => $pdo->lastInsertId()
        ]);

    } elseif ($method === 'PUT') {

        $data = json_decode(file_get_contents('php://input'), true);

        $sql = "UPDATE products SET
                title = ?,
                description = ?,
                category = ?,
                price = ?,
                stock = ?,
                brand = ?,
                thumbnail = ?
                WHERE id = ?";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $data['title'],
            $data['description'] ?? '',
            $data['category'] ?? '',
            $data['price'],
            $data['stock'] ?? 0,
            $data['brand'] ?? '',
            $data['thumbnail'] ?? '',
            $data['id']
        ]);

        echo json_encode([
            'message' => 'Produk berhasil diperbarui'
        ]);

    } elseif ($method === 'DELETE') {

        $id = $_GET['id'] ?? null;

        $stmt = $pdo->prepare(
            "DELETE FROM products WHERE id = ?"
        );
        $stmt->execute([$id]);

        echo json_encode([
            'message' => 'Produk berhasil dihapus'
        ]);

    } else {
        http_response_code(405);

        echo json_encode([
            'message' => 'Method tidak diizinkan'
        ]);
    }

} catch (PDOException $e) {

    http_response_code(500);

    echo json_encode([
        'status' => 'error',
        'message' => 'Terjadi kesalahan pada database'
    ]);
}
