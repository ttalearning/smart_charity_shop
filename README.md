# Smart Charity Shop

Một nền tảng quản lý cửa hàng từ thiện (Smart Charity Shop). README này mô tả tổng quan dự án và hướng dẫn chạy Backend (BE) và Frontend (FE) dựa trên thành phần ngôn ngữ hiện có trong repo (Dart, HTML, C#). Nếu cấu trúc thư mục hoặc công nghệ của bạn khác, vui lòng cho mình biết để mình cập nhật README cho chính xác.

## Mục lục
- Tổng quan
- Kiến trúc & Ngôn ngữ
- Yêu cầu trước khi cài đặt
- Cấu trúc thư mục (ví dụ)
- Biến môi trường (.env) mẫu
- Chạy nhanh (Quick Start)
  - Backend (C# / ASP.NET Core)
  - Frontend (Dart / Flutter & Web)
- Database: migration & seed
- Docker & Docker Compose (mẫu)
- Kiểm thử (Testing)
- Lint & Format
- Triển khai (Deployment)
- Gặp lỗi? Troubleshooting
- Hướng dẫn đóng góp
- License & Liên hệ

---

## Tổng quan
Smart Charity Shop là một hệ thống quản lý quyên góp, bán hàng, và báo cáo cho tổ chức từ thiện. Repo có thành phần ngôn ngữ chính gồm Dart (thường là Flutter app), HTML (web) và C# (có thể là backend ASP.NET Core). README này cung cấp hướng dẫn chung để chạy và phát triển.

## Kiến trúc & Ngôn ngữ
- Frontend: Flutter (Dart) cho mobile/web; có thể có thư mục web tĩnh (HTML).
- Backend: C# (ASP.NET Core hoặc .NET Web API)
- Database: PostgreSQL hoặc SQL Server (tuỳ cấu hình)

Nếu thực tế bạn dùng công nghệ khác (ví dụ Node.js), mình sẽ cập nhật lại lệnh tương ứng.

## Yêu cầu trước khi cài đặt
- Git
- .NET SDK 7+ (hoặc version tương ứng với project C#)
- Flutter SDK (nếu frontend là Flutter)
- PostgreSQL / SQL Server hoặc Docker
- (Tùy chọn) Docker & Docker Compose

## Cấu trúc thư mục (ví dụ)
- /backend                 -> mã nguồn C# (ASP.NET Core Web API)
- /frontend/flutter_app    -> Flutter (Dart) app (mobile / web)
- /web                    -> HTML tĩnh (nếu có)
- /docs                   -> tài liệu

Điều chỉnh theo cấu trúc thực tế của repo nếu khác.

## Biến môi trường (.env) mẫu
Backend (ví dụ ASP.NET Core, có thể dùng User Secrets hoặc environment variables):
ASPNETCORE_ENVIRONMENT=Development
ConnectionStrings__DefaultConnection=Host=localhost;Port=5432;Database=smart_charity_db;Username=postgres;Password=postgres
JWT__Key=thay_bang_khoa_bi_mat
CORS__Origins=http://localhost:3000

Frontend (Flutter - nếu cần file .env, hoặc config trong lib):
API_BASE_URL=http://localhost:5000/api

Lưu ý: Không commit .env vào repository.

## Chạy nhanh (Quick Start)
Giả sử repo có 2 phần chính: `backend/` (C#) và `frontend/flutter_app/` (Flutter).

### Chạy Backend (C# / ASP.NET Core)
1. Vào thư mục backend:
   cd backend

2. Cài dependencies & build
   dotnet restore
   dotnet build

3. Cấu hình biến môi trường (hoặc tạo appsettings.Development.json) theo mẫu ở trên.

4. Cài dotnet-ef (nếu chưa có) và chạy migration (nếu dùng EF Core):
   dotnet tool install --global dotnet-ef --version 7.0.0 || true
   dotnet ef database update

   Hoặc nếu chưa có migration:
   dotnet ef migrations add Init
   dotnet ef database update

5. Chạy ứng dụng ở chế độ phát triển:
   dotnet run --urls "http://localhost:5000"

6. Build production và chạy:
   dotnet publish -c Release -o out
   dotnet out/YourAppAssembly.dll

Kiểm tra: truy cập http://localhost:5000/health hoặc endpoint API chính. Nếu có Swagger: http://localhost:5000/swagger

### Chạy Frontend (Flutter - Mobile / Web)
1. Vào thư mục flutter app:
   cd frontend/flutter_app

2. Cài dependencies:
   flutter pub get

3. Chạy ở chế độ phát triển (web):
   flutter run -d chrome
   Hoặc chạy web server tĩnh (port 3000):
   flutter run -d web-server --web-hostname localhost --web-port 3000

   Chạy trên thiết bị Android/iOS: kết nối device hoặc giả lập rồi `flutter run`

4. Build production web:
   flutter build web --release
   Build sẽ tạo thư mục `build/web` chứa file HTML/JS/CSS tĩnh, có thể phục vụ bằng Nginx hoặc bất kỳ static server nào.

Nếu frontend thực tế là một trang HTML tĩnh trong `/web`, đơn giản mở `index.html` hoặc dùng `npx serve web` để phục vụ.

## Database: migration & seed
- EF Core (C#):
  dotnet ef migrations add <Name>
  dotnet ef database update
  (Tạo seed data trong DbContext hoặc migration)

- Nếu dùng SQL scripts: chạy file SQL seed vào DB

Luôn backup data trước khi chạy migration trên môi trường production.

## Docker & Docker Compose (mẫu)
Dưới đây là ví dụ docker-compose để chạy DB + backend + frontend tĩnh. Điều chỉnh image/command theo thực tế.

```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: smart_charity_db
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - '5432:5432'

  backend:
    build: ./backend
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__DefaultConnection=Host=db;Port=5432;Database=smart_charity_db;Username=postgres;Password=postgres
    ports:
      - '5000:5000'
    depends_on:
      - db

  frontend:
    image: nginx:alpine
    volumes:
      - ./frontend/flutter_app/build/web:/usr/share/nginx/html:ro
    ports:
      - '3000:80'
    depends_on:
      - backend

volumes:
  db-data:
```

Chạy: docker-compose up --build

## Kiểm thử (Testing)
- Backend (C#):
  dotnet test ./backend/tests
- Frontend (Flutter):
  flutter test

Viết test cho service/core logic và component quan trọng.

## Lint & Format
- Backend: dotnet format hoặc dùng analyzer trong CI
  dotnet tool install -g dotnet-format
  dotnet format
- Frontend: flutter format .
  flutter analyze

## Triển khai (Deployment)
- Backend: deploy container hoặc sử dụng dịch vụ như Azure App Service, AWS Elastic Beanstalk, DigitalOcean App Platform. Sử dụng CI (GitHub Actions) để build -> test -> push image -> deploy.
- Frontend: deploy `build/web` lên Netlify/Vercel/Cloud Storage + CDN hoặc serve qua Nginx.

## Gặp lỗi? Troubleshooting
- Lỗi kết nối DB: kiểm tra ConnectionStrings và port, user/password, DB đã được tạo chưa.
- CORS: nếu FE không kết nối BE, mở cấu hình CORS trong backend và cho phép origin của FE (http://localhost:3000 hoặc http://localhost:5173).
- Lỗi migration: kiểm tra version EF Core và các migration đã được áp dụng.

## Hướng dẫn đóng góp
1. Fork repository
2. Tạo branch: feature/<mô-tả> hoặc fix/<mô-tả>
3. Viết code, thêm test, chạy lint/format
4. Mở PR mô tả chi tiết thay đổi

## License & Liên hệ
- License: (thêm license phù hợp, ví dụ MIT)
- Liên hệ: @ttalearning (GitHub) hoặc email trong profile

---

Ghi chú: README trên là template chi tiết dựa trên các ngôn ngữ được phát hiện trong repo. Nếu bạn muốn mình cập nhật chính xác theo cấu trúc và script thực tế (ví dụ tên thư mục backend/frontend, các script trong package.json hoặc file .sln/.csproj, tên Flutter app), cho mình quyền truy cập nhiều hơn vào cấu trúc repo hoặc paste ra các file chính (ví dụ tree của repo).