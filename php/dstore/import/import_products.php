<?php

header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../config/database.php';

try {
    $limit = 100;
    $skip = 0;
    $totalImported = 0;
    $totalProducts = 0;

    $sql = "INSERT INTO products (
                dummyjson_id,
                title,
                description,
                category,
                price,
                discountPercentage,
                rating,
                stock,
                brand,
                thumbnail,
                images
            ) VALUES (
                :dummyjson_id,
                :title,
                :description,
                :category,
                :price,
                :discountPercentage,
                :rating,
                :stock,
                :brand,
                :thumbnail,
                :images
            )
            ON DUPLICATE KEY UPDATE
                title = VALUES(title),
                description = VALUES(description),
                category = VALUES(category),
                price = VALUES(price),
                discountPercentage = VALUES(discountPercentage),
                rating = VALUES(rating),
                stock = VALUES(stock),
                brand = VALUES(brand),
                thumbnail = VALUES(thumbnail),
                images = VALUES(images)";

    $stmt = $pdo->prepare($sql);

    do {
        $url = "https://dummyjson.com/products?limit=$limit&skip=$skip";

        $curl = curl_init($url);

        curl_setopt_array($curl, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_FOLLOWLOCATION => true
        ]);

        $response = curl_exec($curl);
        $httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        $curlError = curl_error($curl);

        curl_close($curl);

        if ($response === false || $httpCode !== 200) {
            throw new Exception(
                "Gagal mengambil data DummyJSON: " . $curlError
            );
        }

        $data = json_decode($response, true);

        if (!isset($data['products'])) {
            throw new Exception('Format data DummyJSON tidak valid.');
        }

        $totalProducts = $data['total'];

        foreach ($data['products'] as $product) {
            $stmt->execute([
                ':dummyjson_id' => $product['id'],
                ':title' => $product['title'],
                ':description' => $product['description'],
                ':category' => $product['category'],
                ':price' => $product['price'],
                ':discountPercentage' => $product['discountPercentage'],
                ':rating' => $product['rating'],
                ':stock' => $product['stock'],
                ':brand' => $product['brand'] ?? null,
                ':thumbnail' => $product['thumbnail'],
                ':images' => json_encode(
                    $product['images'] ?? [],
                    JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE
                )
            ]);

            $totalImported++;
        }

        $skip += $limit;

    } while ($skip < $totalProducts);

    echo json_encode([
        'status' => 'success',
        'message' => 'Import produk berhasil!',
        'total_products' => $totalProducts,
        'processed' => $totalImported
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    http_response_code(500);

    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
}
