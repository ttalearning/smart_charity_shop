````markdown name=README.md
# Smart Charity Shop

Một nền tảng quản lý cửa hàng từ thiện — README này hướng dẫn chi tiết cách cài đặt và chạy local cho Backend (C#/.NET) và Frontend (Flutter/Dart), bao gồm chỉ dẫn chạy file SmartCharityShopDB.sql và cách scaffold model từ database. Không sử dụng Docker trong hướng dẫn này.

---

📌 Tóm tắt nhanh
- Ngôn ngữ chính: Dart (Flutter), HTML, C#
- Mục tiêu: hướng dẫn cài đặt & chạy local cho BE/FE, chạy file SQL khởi tạo DB, và mẫu pipeline CI (GitHub Actions).

🔧 Yêu cầu
- Git
- .NET SDK 7+
- Flutter SDK
- SQL Server (ví dụ: SQLEXPRESS)

---

🗂️ Cấu trúc thư mục (ví dụ)
- backend/                → mã nguồn C# (.sln, .csproj)
- frontend/flutter_app/   → Flutter (pubspec.yaml)
- web/                    → HTML tĩnh (nếu có)

---

⚙️ Cấu hình môi trường (ví dụ)
Backend (appsettings.Development.json hoặc environment variables)
- ASPNETCORE_ENVIRONMENT=Development
- ConnectionStrings__DefaultConnection=Server=.\SQLEXPRESS;Database=SmartCharityShopDB;Trusted_Connection=True;Trust Server Certificate=True
- JWT__Key=<your-secret>
- CORS__Origins=http://localhost:3000

Frontend (Flutter)
- API_BASE_URL=http://localhost:5000/api (cấu hình trong code hoặc dùng flutter_dotenv)

---

🚀 Cài đặt & chạy — Phân rõ FE / BE

1) Backend (C# / ASP.NET Core) — 🖥️

- Vào thư mục backend:
  cd backend

- Cài dependencies & build:
  dotnet restore
  dotnet build

- Nếu cần khởi tạo database từ file SQL (SmartCharityShopDB.sql):
  + Bằng SQL Server Management Studio (SSMS): mở file SmartCharityShopDB.sql, kết nối tới instance (ví dụ .\SQLEXPRESS) và chạy tất cả để tạo cấu trúc và dữ liệu mẫu.
  + Bằng dòng lệnh (sqlcmd):
    sqlcmd -S .\SQLEXPRESS -i path\to\SmartCharityShopDB.sql
    (thay path\to\ bằng đường dẫn tới file trong repo)

- Hoặc khởi tạo DB bằng EF Core migrations (nếu dự án dùng code-first):
  dotnet tool install --global dotnet-ef --version 7.0.0 || true
  dotnet ef migrations add InitialCreate
  dotnet ef database update

- Tạo model từ database (reverse engineering) — ví dụ nếu muốn scaffold các entity từ DB:
  Scaffold-DbContext "Data Source=.\SQLEXPRESS;Initial Catalog=SmartCharityShopDB;Integrated Security=True;Trust Server Certificate=True" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Context SmartCharityContext -DataAnnotations -Force

  Lưu ý khi chạy Scaffold-DbContext:
  - Đảm bảo cơ sở dữ liệu SmartCharityShopDB đã tồn tại trước khi chạy.
  - Tùy chọn -Force sẽ ghi đè các file trong thư mục Models; sao lưu mã tuỳ chỉnh nếu cần.

- Chạy server ở chế độ phát triển:
  dotnet run --urls "http://localhost:5000"

- Kiểm tra: http://localhost:5000/health hoặc http://localhost:5000/swagger (nếu có)

2) Frontend (Flutter - Dart) — 📱 / 🌐

- Vào thư mục Flutter:
  cd frontend/flutter_app

- Lấy dependency:
  flutter pub get

- Chạy ở chế độ phát triển (web):
  flutter run -d chrome
  Hoặc chạy web server:
  flutter run -d web-server --web-hostname localhost --web-port 3000

- Chạy trên thiết bị Android/iOS:
  - Kết nối emulator/device rồi `flutter run`

- Build production web:
  flutter build web --release
  Output: build/web (phục vụ bằng static host nếu cần)

---

🧩 Database & lưu ý làm việc với mô hình
- Nếu dùng file SmartCharityShopDB.sql: chạy file trước để tạo schema và dữ liệu mẫu, sau đó scaffold hoặc kết nối từ ứng dụng.
- Nếu dùng code-first: tạo entities → tạo migration → cập nhật database bằng `dotnet ef database update`.
- Tránh ghi đè mã tuỳ chỉnh khi dùng reverse engineering; lưu code tùy chỉnh ở nơi riêng biệt hoặc loại trừ file khỏi scaffold.

---

⚙️ CI (GitHub Actions) — Mẫu pipeline (build & test)
Tạo file `.github/workflows/ci.yml` với nội dung mẫu sau để tự động build & test Backend và Frontend (không dùng Docker):

```yaml
name: CI

on: [push, pull_request]

jobs:
  build-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '7.0.x'
      - name: Restore & Build
        run: |
          cd backend
          dotnet restore
          dotnet build --no-restore --configuration Release
      - name: Run backend tests
        run: |
          cd backend
          dotnet test --no-build --verbosity normal

  build-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - name: Install deps & Test
        run: |
          cd frontend/flutter_app
          flutter pub get
          flutter test --coverage || true
      - name: Build web (optional)
        run: |
          cd frontend/flutter_app
          flutter build web --release
```

---

🐞 Troubleshooting nhanh
- Lỗi kết nối SQL Server: kiểm tra instance name (ví dụ .\SQLEXPRESS), quyền truy cập và chuỗi kết nối.
- Lỗi Scaffold: đảm bảo gói Microsoft.EntityFrameworkCore.SqlServer đã tham chiếu trong project và chuỗi kết nối đúng.
- Lỗi Flutter: chạy `flutter doctor` để kiểm tra môi trường.

---

🧭 Hướng dẫn đóng góp
1. Fork → tạo branch `feature/<mô-tả>` hoặc `fix/<mô-tả>`
2. Viết code, thêm test nếu cần
3. Mở PR mô tả rõ thay đổi và cách chạy local

🔒 License & Liên hệ
- License: thêm file LICENSE (ví dụ MIT) nếu cần
- Liên hệ: @ttalearning

````