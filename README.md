# Dompet Kampus Global - Aplikasi E-Wallet

Dompet Kampus Global adalah aplikasi dompet elektronik (e-money) komprehensif yang dirancang secara khusus untuk memfasilitasi kebutuhan transaksi keuangan mahasiswa di lingkungan kampus maupun di luar kampus dengan aman, cepat, dan efisien. Sistem ini dibangun dengan penekanan kuat pada arsitektur yang dapat diskalakan (scalable), kemudahan pemeliharaan (maintainability), dan keamanan data pengguna.

Aplikasi ini tidak hanya berfungsi sebagai alat pembayaran standar, tetapi juga terintegrasi dengan berbagai layanan akademik dan gaya hidup mahasiswa.

## Profil Mahasiswa

* **Nama:** David Saputra
* **Kelas:** TI 23 M SE
* **Prodi:** Teknik Informatika
* **Jurusan:** Software Engineer

## Fitur Utama (Core Features)

1. **Manajemen Saldo & Top-up:** Pengguna dapat mengisi saldo dari berbagai bank dan metode pembayaran.
2. **Transfer Peer-to-Peer:** Memungkinkan mahasiswa mentransfer dana ke sesama mahasiswa secara real-time tanpa biaya admin.
3. **Pembayaran QRIS:** Terintegrasi dengan pemindai QR untuk pembayaran cepat di kantin, koperasi, atau merchant kampus lainnya.
4. **Pembayaran Tagihan Kampus (UKT):** Memudahkan pembayaran Uang Kuliah Tunggal (UKT) atau tagihan akademik lainnya secara langsung.
5. **Riwayat Transaksi:** Pencatatan setiap transaksi masuk dan keluar yang transparan dan dapat dilacak kapan saja.
6. **Autentikasi Dua Faktor (2FA):** Menjaga keamanan akun dengan lapisan perlindungan ganda menggunakan OTP melalui email atau SMS.

## Arsitektur Sistem

Proyek ini mengadopsi arsitektur client-server terpisah yang sangat terdekopel (decoupled). Arsitektur ini terdiri dari antarmuka aplikasi seluler modern (Frontend) dan layanan API backend yang tangguh.

### 1. Frontend (Aplikasi Seluler)
Dibangun menggunakan framework Flutter untuk memberikan pengalaman pengguna (User Experience) yang mulus di platform Android maupun iOS dengan satu basis kode.
* **Framework Utama:** Flutter (Dart) - Memastikan performa 60fps yang stabil dengan UI/UX yang responsif.
* **Manajemen State:** BLoC (Business Logic Component) melalui `flutter_bloc` untuk transisi state yang dapat diprediksi, memisahkan logika dari tampilan sepenuhnya.
* **Routing (Navigasi):** `go_router` untuk routing deklaratif dan dukungan deep linking (untuk navigasi ke halaman spesifik dari notifikasi atau tautan web).
* **Dependency Injection:** `get_it` untuk memisahkan dependensi komponen (repositories, API clients) dan meningkatkan testabilitas unit UI.
* **Networking:** `dio` untuk menangani permintaan HTTP (REST) dengan interceptor, pengelolaan token, dan logging request/response.
* **Penyimpanan Lokal:** `flutter_secure_storage` untuk menyimpan JWT token secara aman, dan `shared_preferences` untuk manajemen preferensi pengguna (seperti mode gelap/terang).
* **Integrasi Perangkat Keras:** `mobile_scanner` untuk kemampuan pemindaian kode QR secara instan.
* **Layanan Pihak Ketiga:** Firebase Auth dan Messaging untuk autentikasi eksternal (Google Sign-In) dan push notification.

### 2. Backend (RESTful API)
Dikembangkan menggunakan bahasa pemrograman Go (Golang) untuk menangani permintaan dalam jumlah besar (high throughput) dan latensi rendah (low latency) secara bersamaan (concurrent) dengan efisien.
* **Bahasa Pemrograman:** Go (Golang) versi 1.21.
* **Web Framework:** Framework HTTP Gin untuk routing yang sangat cepat dan pemrosesan middleware yang ringan.
* **Database Relasional:** MySQL yang diakses melalui GORM (Go Object Relational Mapper) untuk persistensi data pengguna, dompet, dan transaksi.
* **Caching & Sesi:** Redis digunakan untuk caching data yang sering diakses (seperti profil pengguna) dan mengelola state sementara (seperti kode OTP dan rate limiting).
* **Keamanan:**
  * JWT (JSON Web Tokens) untuk autentikasi stateless dan otorisasi endpoint.
  * 2FA (Two-Factor Authentication) menggunakan pembuatan OTP yang aman.
  * Firebase Admin SDK untuk cloud messaging dan validasi autentikasi eksternal.
  * Hashing password dengan Bcrypt.
* **Layanan Email:** Paket `gomail` digunakan untuk pengiriman email transaksional (seperti resi, verifikasi akun).

## Demo Aplikasi & Mockup

[![Demo Aplikasi](https://img.youtube.com/vi/I1w_7sJjH0k/maxresdefault.jpg)](https://youtu.be/I1w_7sJjH0k)

Link video demo: [https://youtu.be/I1w_7sJjH0k](https://youtu.be/I1w_7sJjH0k)

### Kumpulan Mockup UI/UX

- **Halaman Login & OTP**
  ![Halaman Login](assets/images/mockup/halaman%20login.png)
  ![Tampilan Login e-money](assets/images/mockup/tampilan%20login%20e-money.png)
  ![Tampilan OTP e-money](assets/images/mockup/tampilan%20OTP%20e-money.png)

- **Dashboard & E-money**
  ![Halaman Dashboard](assets/images/mockup/halaman%20dashbaord.png)
  ![Halaman Dashboard e-money](assets/images/mockup/halaman%20dashboard%20e-money.png)
  ![Halaman Top up e-money](assets/images/mockup/halaman%20top%20up%20e-money.png)
  ![Halaman Riwayat e-money](assets/images/mockup/halaman%20riwayat%20e-money.png)

- **Store & Keranjang**
  ![Halaman Keranjang](assets/images/mockup/halaman%20keranjang.png)
  ![Halaman Checkout](assets/images/mockup/halaman%20checkout.png)
  ![Halaman Pesanan Saya](assets/images/mockup/halaman%20pesanan%20saya.png)
  ![Halaman Detail Pesan](assets/images/mockup/halaman%20detail%20pesan.png)

- **Akun & Tema**
  ![Halaman Akun e-money](assets/images/mockup/halaman%20akun%20e-money.png)
  ![Tema Gelap](assets/images/mockup/tema%20gelap.png)

## Prinsip Clean Code & Pola Arsitektur

Baik kode frontend maupun backend sangat mematuhi prinsip Clean Architecture dan Clean Code (seperti SOLID principles) untuk memastikan sistem tetap mudah dipelihara (maintainable) dan mudah diskalakan seiring bertambahnya fitur dan kompleksitas.

### Pendekatan Clean Code di Backend
* **Pemisahan Perhatian (Separation of Concerns):** Struktur direktori (`config`, `database`, `handlers`, `middleware`, `models`, `routes`, `services`) menerapkan batas yang sangat jelas antara lapisan presentasi (handler/controller), logika bisnis murni, dan lapisan akses data (database).
* **Pola Service Layer:** Aturan bisnis diisolasi di dalam paket `services`. Handlers (controller) hanya bertugas mem-parsing permintaan HTTP dan memformat respons JSON, kemudian mendelegasikan semua logika bisnis yang kompleks ke services.
* **Middleware Reusability:** Perhatian lintas sektoral (cross-cutting concerns) seperti autentikasi JWT, validasi input, dan logging HTTP ditangani dengan rapi di dalam paket `middleware`, menjaga definisi rute tetap deklaratif dan bersih.
* **Dependency Injection:** Koneksi database, instance Redis, dan konfigurasi lainnya disuntikkan (injected) ke dalam rute dan services. Ini menghindari penggunaan global state (variabel global), sehingga pengujian unit (unit testing) dengan mock objek menjadi jauh lebih mudah.

### Pendekatan Clean Code di Frontend
* **Pola BLoC (Business Logic Component):** Memisahkan logika bisnis sepenuhnya dari lapisan antarmuka pengguna (UI/Widget). Widget hanya bertugas merender tampilan (build), memancarkan event pengguna (klik tombol), dan bereaksi secara pasif terhadap perubahan state dari BLoC. Hal ini membuat UI sama sekali tidak menyadari mekanisme pengambilan data (fetching) dari API.
* **Struktur Berbasis Fitur (Feature-Based Architecture):** Kode diatur berdasarkan fitur (misal: `lib/features/auth`, `lib/features/wallet`), bukan berdasarkan jenis teknis (seperti `lib/blocs`, `lib/screens`). Ini memudahkan tim developer (Software Engineer) mencari file yang terkait dengan satu fitur dan memperluas aplikasi secara kolaboratif.
* **Immutability (Ketidakubah-ubahan):** Objek state dan event menggunakan package `equatable` untuk memaksakan immutability (tidak dapat diubah setelah dibuat). Hal ini mencegah efek samping (side-effects) bug yang tidak disengaja dan memastikan framework Flutter dapat membandingkan pembaruan UI secara efisien dan andal.
* **Service Locator (DI):** `get_it` menyediakan cara terpusat, bersih, dan konsisten untuk meregistrasikan dan mengambil instance singleton dari repository (data provider) dan client jaringan (REST client), sehingga kita tidak perlu mem-passing objek secara berantai melalui konstruktor widget.

## Panduan Memulai (Getting Started)

### Prasyarat
* Flutter SDK (>=3.0.0)
* Go (>=1.21)
* MySQL Server (berjalan di port 3306)
* Redis Server (berjalan di port 6379)

### Persiapan Backend
1. Masuk ke direktori `backend-emoney`.
2. Salin `.env.example` menjadi `.env` dan konfigurasikan detail koneksi database, Redis, port server, dan kredensial SMTP Anda.
3. Pastikan `firebase_service_account.json` telah diunduh dari Firebase Console dan dikonfigurasi dengan benar untuk mengakses layanan Firebase Admin.
4. Jalankan perintah `go mod download` untuk mengunduh dan menginstal semua dependensi Go.
5. Jalankan perintah `go run main.go` untuk memulai server API backend (default akan berjalan di port 8080).

### Persiapan Frontend
1. Buka terminal dan masuk ke direktori utama (root).
2. Jalankan perintah `flutter pub get` untuk mengunduh dependensi Dart/Flutter yang dibutuhkan (tercantum di `pubspec.yaml`).
3. Pastikan file konfigurasi Firebase dari console (`google-services.json` untuk Android / `GoogleService-Info.plist` untuk iOS) ditempatkan dengan benar di direktori platform masing-masing.
4. Siapkan perangkat fisik atau emulator.
5. Jalankan `flutter run` untuk melakukan proses build dan meluncurkan aplikasi di perangkat Anda.
