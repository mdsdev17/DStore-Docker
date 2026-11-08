# DStore - Flutter Product CRUD with Docker Backend

DStore adalah aplikasi katalog produk berbasis Flutter yang terhubung dengan backend PHP API dan database MySQL. Proyek ini juga menggunakan Docker Compose untuk menjalankan berbagai layanan web development.

## Teknologi yang Digunakan

- **Frontend Mobile:** Flutter dan Dart
- **Backend API:** PHP
- **Database:** MySQL
- **HTTP Client:** Dio
- **State Management:** Provider
- **Routing:** GoRouter
- **Containerization:** Docker dan Docker Compose
- **Backend Tambahan:** Python FastAPI dan Node.js

## Fitur Aplikasi

- Menampilkan daftar produk
- Melihat detail produk
- Menambahkan produk
- Mengubah data produk
- Menghapus produk
- Pencarian produk
- Filter kategori
- Pagination 25 produk per halaman

## Struktur Proyek

```text
DStore-Docker/
├── frontend/              # Node.js dan WebSocket
├── mobile/                # Aplikasi Flutter DStore
│   ├── lib/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── routes/
│   │   ├── screens/
│   │   └── services/
├── php/                   # PHP API dan konfigurasi database
│   └── dstore/
│       ├── api/
│       ├── config/
│       └── import/
├── python/                # Python FastAPI
├── mosquitto/             # Konfigurasi MQTT
├── Dockerfile
├── docker-compose.yml
├── .env.example
└── README.md
```

## Menjalankan Backend dengan Docker

Pastikan Docker Desktop sudah berjalan.

1. Clone repository:

```bash
git clone https://github.com/mdsdev17/DStore-Docker.git
cd DStore-Docker
```

2. Buat file `.env` berdasarkan template:

```powershell
Copy-Item .env.example .env
```

3. Sesuaikan nilai konfigurasi di file `.env`.

4. Jalankan seluruh service:

```bash
docker compose up -d --build
```

5. Periksa status container:

```bash
docker compose ps
```

## Daftar Layanan

| Layanan | Port |
|---|---:|
| Node.js Frontend | 3000 |
| PHP API | 8080 |
| Python FastAPI | 8000 |
| phpMyAdmin | 8081 |
| pgAdmin | 5050 |
| Mongo Express | 8082 |
| MySQL | 3306 |
| PostgreSQL | 5432 |
| MongoDB | 27017 |
| MQTT | 1883 |
| MQTT WebSocket | 9001 |
| RabbitMQ | 5672 |
| RabbitMQ Management | 15672 |

## Menjalankan Aplikasi Flutter

Masuk ke folder mobile:

```bash
cd mobile
```

Ambil dependency:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Untuk perangkat Android fisik, sesuaikan alamat API dengan IPv4 laptop yang menjalankan Docker:

```bash
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8080/dstore/api/
```

Untuk Android Emulator, alamat default API menggunakan `10.0.2.2`.

Pastikan perangkat dan laptop berada pada jaringan yang sama serta port API dapat diakses.

## Menjalankan dan Menghentikan Docker

Menjalankan:

```bash
docker compose up -d
```

Menghentikan container:

```bash
docker compose down
```

## Repository

GitHub: https://github.com/mdsdev17/DStore-Docker