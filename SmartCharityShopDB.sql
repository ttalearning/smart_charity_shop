

IF DB_ID('SmartCharityShopDB') IS NOT NULL
BEGIN
    ALTER DATABASE SmartCharityShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SmartCharityShopDB;
END
GO

CREATE DATABASE SmartCharityShopDB;
GO
USE SmartCharityShopDB;
GO

CREATE TABLE NguoiDung (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    MatKhau NVARCHAR(255) NULL,
    VaiTro NVARCHAR(20) DEFAULT 'User',  -- User | Admin
    GoogleId NVARCHAR(100) NULL,
    AvatarUrl NVARCHAR(255) NULL,
    KieuDangNhap NVARCHAR(20) DEFAULT 'Local',
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1
);
GO

CREATE TABLE LoaiSanPham (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE SanPham (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TenSanPham NVARCHAR(150) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    MoTa NVARCHAR(MAX),
    AnhChinh NVARCHAR(255), -- Ảnh chính hiển thị
    LoaiId INT NOT NULL,
    NgayTao DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LoaiId) REFERENCES LoaiSanPham(Id) ON DELETE CASCADE
);
GO

CREATE TABLE HinhAnhSanPham (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SanPhamId INT NOT NULL,
    Url NVARCHAR(255) NOT NULL,
    IsChinh BIT DEFAULT 0,
    FOREIGN KEY (SanPhamId) REFERENCES SanPham(Id) ON DELETE CASCADE
);
GO

CREATE TABLE ChienDich (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TenChienDich NVARCHAR(200) NOT NULL,
    MoTa NVARCHAR(MAX),
    HinhAnhChinh NVARCHAR(255), -- ảnh đại diện chính
    MucTieu DECIMAL(18,2) NOT NULL DEFAULT 0,
    SoTienHienTai DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai NVARCHAR(20) DEFAULT N'Đang diễn ra',
    DiaDiem NVARCHAR(255) NULL,
    NguoiTaoId INT NULL,
    NgayBatDau DATETIME DEFAULT GETDATE(),
    NgayKetThuc DATETIME NULL,
    FOREIGN KEY (NguoiTaoId) REFERENCES NguoiDung(Id) ON DELETE SET NULL
);
GO

CREATE TABLE HinhAnhChienDich (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ChienDichId INT NOT NULL,
    Url NVARCHAR(255) NOT NULL,
    IsChinh BIT DEFAULT 0,
    FOREIGN KEY (ChienDichId) REFERENCES ChienDich(Id) ON DELETE CASCADE
);
GO



CREATE TABLE HoaDon (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NguoiDungId INT NOT NULL,
    TongTienHang DECIMAL(18,2) NOT NULL DEFAULT 0,
    PhiShip DECIMAL(18,2) NOT NULL DEFAULT 0,
    GiamGia DECIMAL(18,2) NOT NULL DEFAULT 0,
    Thue DECIMAL(18,2) NOT NULL DEFAULT 0,
    TongThanhToan AS 
       (ROUND((ISNULL(TongTienHang,0)+ISNULL(PhiShip,0)+ISNULL(Thue,0)-ISNULL(GiamGia,0)),2)) PERSISTED,

    LoaiThanhToan NVARCHAR(50) DEFAULT N'COD',             
    TrangThaiThanhToan NVARCHAR(20) DEFAULT N'Pending',    
    TrangThaiDonHang NVARCHAR(20) DEFAULT N'Pending',      

    TenNguoiNhan NVARCHAR(120) NULL,
    SoDienThoai NVARCHAR(20) NULL,
    DiaChiNhan NVARCHAR(300) NULL,
    GhiChu NVARCHAR(500) NULL,

    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NULL,

    FOREIGN KEY (NguoiDungId) REFERENCES NguoiDung(Id) ON DELETE CASCADE
);
GO

ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TrangThaiTT
CHECK (TrangThaiThanhToan IN (N'Pending', N'Success', N'Failed', N'Refunded'));

ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TrangThaiDH
CHECK (TrangThaiDonHang IN (N'Pending', N'Processing', N'Shipping', N'Completed', N'Canceled'));
GO

CREATE TABLE ChiTietHoaDon (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    HoaDonId INT NOT NULL,
    SanPhamId INT NOT NULL,
    TenSanPham NVARCHAR(255) NULL,
    GiaLucBan DECIMAL(18,2) NOT NULL,
    SoLuong INT NOT NULL,
    ThanhTien AS (ROUND(ISNULL(GiaLucBan,0)*ISNULL(SoLuong,0),2)) PERSISTED,

    FOREIGN KEY (HoaDonId) REFERENCES HoaDon(Id) ON DELETE CASCADE,
    FOREIGN KEY (SanPhamId) REFERENCES SanPham(Id) ON DELETE CASCADE
);
GO

CREATE INDEX IX_ChiTietHoaDon_HoaDonId ON ChiTietHoaDon(HoaDonId);
CREATE INDEX IX_ChiTietHoaDon_SanPhamId ON ChiTietHoaDon(SanPhamId);
GO


CREATE TABLE PaymentTransaction (	
    Id INT IDENTITY(1,1) PRIMARY KEY,
    HoaDonId INT NOT NULL,
    Provider NVARCHAR(20) NOT NULL,         
    ProviderTransId NVARCHAR(100) NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT N'VND',
    Status NVARCHAR(20) NOT NULL,           
    Payload NVARCHAR(MAX) NULL,            
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),

    FOREIGN KEY (HoaDonId) REFERENCES HoaDon(Id) ON DELETE CASCADE
);
GO

CREATE INDEX IX_Payment_Order ON PaymentTransaction(HoaDonId);
CREATE INDEX IX_Payment_Provider ON PaymentTransaction(Provider, CreatedAt DESC);
GO


CREATE TABLE [dbo].[DongGop] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NguoiDungId] INT NOT NULL,
    [ChienDichId] INT NOT NULL,
    [SoTien] DECIMAL(18,2) NOT NULL,
    [LoaiNguon] NVARCHAR(50) NULL,
    [NgayTao] DATETIME NULL,
    CONSTRAINT [FK_DongGop_NguoiDung] FOREIGN KEY ([NguoiDungId]) REFERENCES [dbo].[NguoiDung]([Id]),
    CONSTRAINT [FK_DongGop_ChienDich] FOREIGN KEY ([ChienDichId]) REFERENCES [dbo].[ChienDich]([Id])
);
ALTER TABLE DongGop
ADD LoiNhan NVARCHAR(200) NULL;


-- trigger
GO
CREATE TRIGGER TRG_Update_TrangThai_ChienDich
ON ChienDich
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE cd
    SET cd.TrangThai = N'Đã kết thúc'
    FROM ChienDich cd
    INNER JOIN inserted i ON cd.Id = i.Id
    WHERE 
        (
            cd.NgayKetThuc IS NOT NULL 
            AND cd.NgayKetThuc <= SYSDATETIME()
        )
        OR cd.SoTienHienTai >= cd.MucTieu;
END
GO
