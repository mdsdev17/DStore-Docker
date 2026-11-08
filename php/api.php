<?php
header('Content-Type: application/json; charset=utf-8');

echo json_encode([
    'service' => 'PHP API',
    'status' => 'running',
    'message' => 'Halo dari PHP API!',
    'time' => date('c')
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
