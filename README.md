# Smart Charity Shop

Một nền tảng quản lý cửa hàng từ thiện — hướng dẫn cài đặt và chạy local cho Backend (C#/.NET) và Frontend (Flutter/Dart). README này không sử dụng Docker và bao gồm hướng dẫn chạy file SmartCharityShopDB.sql cùng cách scaffold model từ database.

----

📌 Tóm tắt nhanh
- Ngôn ngữ chính: Dart (Flutter), HTML, C#
- Mục tiêu: hướng dẫn cài đặt, khởi tạo database (SQL file), scaffold model, và một mẫu pipeline CI (GitHub Actions).

🔧 Yêu cầu
- Git
- .NET SDK 7+
- Flutter SDK
- SQL Server (ví dụ: \\.\SQLEXPRESS)

🗂 Cấu trúc thư mục (ví dụ)
- backend/                → mã nguồn C# (.sln, .csproj)
- frontend/flutter_app/   → Flutter app (pubspec.yaml)
- sql/                    → SmartCharityShopDB.sql (file khởi tạo DB)
- web/                    → HTML tĩnh (nếu có)

----

⚙️ Cấu hình môi trường (ví dụ)
Backend (appsettings.Development.json hoặc environment variables)
- ASPNETCORE_ENVIRONMENT=Development
- ConnectionStrings__DefaultConnection=Server=.\SQLEXPRESS;Database=SmartCharityShopDB;Trusted_Connection=True;Trust Server Certificate=True
- JWT__Key=<your-secret>
- CORS__Origins=http://localhost:3000

Frontend (Flutter)
- API_BASE_URL=http://localhost:5000/api (cấu hình trong code hoặc dùng flutter_dotenv)

----

🚀 Cài đặt & chạy — Phân rõ FE / BE

1) Backend (C# / ASP.NET Core) — 🖥️

- Bước 1 — Chuẩn bị project:
  cd backend
  dotnet restore
  dotnet build

- Bước 2 — Tạo hoặc import database:
  A) Nếu dùng file SQL (khuyến nghị cho lần đầu):
     - Mở SQL Server Management Studio (SSMS), kết nối tới instance (ví dụ .\SQLEXPRESS).
     - Mở file `sql/SmartCharityShopDB.sql` và nhấn Execute để tạo database, schema và dữ liệu mẫu.

     Hoặc dùng sqlcmd (Command Prompt):
     sqlcmd -S .\SQLEXPRESS -i "<path-to-repo>/sql/SmartCharityShopDB.sql"

  B) Nếu bạn muốn dùng EF Core code-first và migration:
     dotnet tool install --global dotnet-ef --version 7.0.0 || true
     dotnet ef migrations add InitialCreate
     dotnet ef database update

- Bước 3 — Scaffold models từ database (reverse engineering):
  Lưu ý: chỉ chạy khi database đã tồn tại. Chạy từ Package Manager Console (Visual Studio) hoặc CLI từ thư mục chứa .csproj.

  Package Manager Console (PMC):
  Scaffold-DbContext "Data Source=.\SQLEXPRESS;Initial Catalog=SmartCharityShopDB;Integrated Security=True;Trust Server Certificate=True" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Context SmartCharityContext -DataAnnotations -Force

  CLI tương đương (dotnet ef):
  dotnet ef dbcontext scaffold "Server=.\SQLEXPRESS;Database=SmartCharityShopDB;Trusted_Connection=True;TrustServerCertificate=True" Microsoft.EntityFrameworkCore.SqlServer --output-dir Models --context SmartCharityContext --data-annotations --force

  Hướng dẫn ngắn:
  - Đảm bảo `Microsoft.EntityFrameworkCore.SqlServer` đã được thêm vào project (dotnet add package Microsoft.EntityFrameworkCore.SqlServer).
  - `-Force` sẽ ghi đè file; sao lưu mã tùy chỉnh nếu cần.

- Bước 4 — Chạy ứng dụng:
  dotnet run --urls "http://localhost:5000"
  Kiểm tra: http://localhost:5000/health hoặc http://localhost:5000/swagger (nếu có)

2) Frontend (Flutter - Dart) — 📱 / 🌐

- Bước 1 — Chuẩn bị project:
  cd frontend/flutter_app
  flutter pub get

- Bước 2 — Chạy trong môi trường phát triển:
  - Web (Chrome): flutter run -d chrome
  - Web server: flutter run -d web-server --web-hostname localhost --web-port 3000
  - Device: kết nối emulator/device → flutter run

- Bước 3 — Build production web:
  flutter build web --release
  Output: build/web (phục vụ bằng static host nếu cần)

----

🧩 Lưu ý về database & mô hình làm việc
- Nếu sử dụng file `sql/SmartCharityShopDB.sql`, chạy file đó trước khi scaffold hoặc trước khi ứng dụng cố gắng kết nối.
- Nếu dùng scaffold (reverse engineering), tách code tùy chỉnh khỏi những file có thể bị ghi đè (sử dụng partial classes hoặc folder riêng).
- Thêm TrustServerCertificate=True nếu gặp lỗi chứng chỉ khi kết nối SQL Server.

----

⚙️ CI (GitHub Actions) — Mẫu pipeline (build & test)
Tạo file `.github/workflows/ci.yml` với nội dung sau để tự động build & test Backend và Frontend (không deploy):

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

----

🐞 Troubleshooting nhanh
- Kết nối SQL Server thất bại: kiểm tra instance name (ví dụ .\SQLEXPRESS), quyền truy cập, và chuỗi kết nối.
- Scaffold lỗi: kiểm tra dependency `Microsoft.EntityFrameworkCore.SqlServer` và chạy lệnh từ thư mục chứa .csproj.
- Flutter lỗi: chạy `flutter doctor` để xác minh môi trường phát triển.

----

🧭 Hướng dẫn đóng góp
1) Fork → tạo branch `feature/<mô-tả>` hoặc `fix/<mô-tả>`
2) Viết code, thêm test nếu cần
3) Mở PR mô tả rõ thay đổi và hướng dẫn chạy local

🔒 License & Liên hệ
- License: thêm file LICENSE (ví dụ MIT) nếu cần
- Liên hệ: @ttalearning
