# Smart Charity Shop

Một nền tảng quản lý cửa hàng từ thiện (charity shop) với Backend (C# / ASP.NET Core) + Frontend (Flutter).  
README này hướng dẫn cách cài đặt & chạy local cho cả hai phần, bao gồm cả khởi tạo database, scaffold model từ DB, và gợi ý CI (GitHub Actions).

---

## 🚀 Tổng quan

- **Ngôn ngữ / công nghệ chính**:  
  – Backend: C# / .NET 7+  
  – Frontend: Flutter / Dart  
- **Mục tiêu**:  
  1. Quản lý sản phẩm, đơn hàng, người dùng cho một cửa hàng từ thiện  
  2. Hỗ trợ chạy local (backend + frontend) từ mã nguồn + database mẫu  
  3. Mẫu pipeline CI để tự động build & test  

---

## 🔧 Yêu cầu môi trường

- Git  
- .NET SDK 7+  
- Flutter SDK  
- SQL Server (ví dụ: SQLEXPRESS hoặc instance tương thích)  

---

## 📁 Cấu trúc thư mục (ví dụ)

```
backend/                ← mã nguồn ASP.NET Core  
frontend/flutter_app/   ← ứng dụng Flutter / Dart  
SmartCharityShopDB.sql   ← file SQL tạo schema + dữ liệu mẫu  
README.md  
.gitignore  
```

---

## ⚙️ Cấu hình môi trường

### Backend

- Biến môi trường hoặc `appsettings.Development.json`:

| Khóa | Mô tả |
|---|---|
| `ASPNETCORE_ENVIRONMENT` | `"Development"` |
| `ConnectionStrings:DefaultConnection` | Chuỗi kết nối tới SQL Server (ví dụ: `Server=.\SQLEXPRESS;Database=SmartCharityShopDB;Trusted_Connection=True;Trust Server Certificate=True`) |
| `JWT:Key` | Khóa bí mật cho JWT |
| `CORS:Origins` | Danh sách origin (ví dụ: `http://localhost:3000`) |

### Frontend (Flutter)

- Biến cấu hình API backend (ví dụ: `API_BASE_URL = http://localhost:5000/api`)  
- Nếu sử dụng gói như `flutter_dotenv`, bạn có thể để trong `.env`  

---

## 🛠️ Cài đặt & chạy

### 1) Backend

```bash
cd backend
dotnet restore
dotnet build
```

Nếu bạn dùng file SQL mẫu:

- Mở **SmartCharityShopDB.sql** trong SQL Server / SSMS hoặc sử dụng `sqlcmd`:
  ```bash
  sqlcmd -S .\SQLEXPRESS -i path\to\SmartCharityShopDB.sql
  ```
- (Tùy chọn) Scaffold model từ DB:
  ```bash
  dotnet tool install --global dotnet-ef --version 7.0.0 || true
  dotnet ef migrations add InitialCreate
  dotnet ef database update

  Scaffold-DbContext "Data Source=.\SQLEXPRESS;Initial Catalog=SmartCharityShopDB;Integrated Security=True;Trust Server Certificate=True" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -Context SmartCharityContext -DataAnnotations -Force
  ```
- Chạy server:
  ```bash
  dotnet run --urls "http://localhost:5000"
  ```
- Kiểm tra endpoints (nếu có):  
  `http://localhost:5000/health` hoặc `http://localhost:5000/swagger`

### 2) Frontend (Flutter)

```bash
cd frontend/flutter_app
flutter pub get
```

- Chạy trên trình duyệt (web):
  ```bash
  flutter run -d chrome
  ```
  hoặc
  ```bash
  flutter run -d web-server --web-hostname localhost --web-port 3000
  ```
- Chạy trên thiết bị Android / iOS:
  ```bash
  flutter run
  ```
- Build phiên bản sản xuất (web):
  ```bash
  flutter build web --release
  ```
  Output sẽ nằm trong `build/web`

---

## 🧩 Database & Mô hình dữ liệu

- Nếu dùng **SmartCharityShopDB.sql**: chạy tệp để tạo schema + dữ liệu mẫu trước khi chạy ứng dụng  
- Nếu dùng **Code-first / Migrations**: tạo entity → migration → `dotnet ef database update`  
- Lưu ý khi scaffold (reverse engineering):  
  – Đảm bảo DB đã tồn tại  
  – Lệnh `-Force` sẽ ghi đè file, nên sao lưu nếu bạn có tùy chỉnh  
  – Bạn có thể loại trừ các file do scaffold tự sinh nếu bạn sẽ thêm logic thủ công  

---

## 🧪 CI / GitHub Actions (mẫu)

Bạn có thể tạo file `.github/workflows/ci.yml` như sau:

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

Bạn có thể mở rộng thêm bước deploy nếu bạn có hạ tầng hosting.

---

## 🛠️ Troubleshooting (gợi ý)

- Lỗi kết nối SQL Server: kiểm tra tên instance (ví dụ `.\\SQLEXPRESS`), quyền truy cập, cấu hình firewall  
- Lỗi scaffold: kiểm tra gói NuGet `Microsoft.EntityFrameworkCore.SqlServer` đã được cài chưa; kiểm tra chuỗi kết nối  
- Lỗi Flutter: chạy `flutter doctor` để kiểm tra môi trường, SDK, bản cập nhật  
- CORS hoặc lỗi API: kiểm tra cấu hình trong backend và origin frontend  

---

## 🤝 Hướng dẫn đóng góp

1. Fork repository  
2. Tạo branch mới: `feature/<mô-tả>` hoặc `fix/<mô-tả>`  
3. Viết code, thêm test nếu có  
4. Mở Pull Request, mô tả rõ thay đổi & cách chạy local  
5. Đảm bảo CI / build vẫn pass  

---

## 📄 License & Liên hệ

- **License**: (nếu bạn muốn) — ví dụ: MIT, Apache 2.0, v.v.  
- **Liên hệ**: bạn có thể thêm email, Telegram, Slack, hoặc GitHub handle  

---

## ℹ️ Thông tin khác

- Hiện tại repo chưa có mô tả, website hoặc topics rõ ràng. Bạn nên cập nhật phần này để giúp người khác dễ tiếp cận.  
- Bạn có thể thêm badges (build status, coverage, license) lên đầu
