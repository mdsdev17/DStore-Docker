<?php

header('Content-Type: application/json; charset=utf-8');

require_once 'config/database.php';

echo json_encode([
    'status' => 'success',
    'message' => 'Koneksi ke database DStore berhasil!'
], JSON_PRETTY_PRINT);