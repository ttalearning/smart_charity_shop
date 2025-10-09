using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

public partial class SmartCharityShopDbContext : DbContext
{
    public SmartCharityShopDbContext()
    {
    }

    public SmartCharityShopDbContext(DbContextOptions<SmartCharityShopDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ChiTietHoaDon> ChiTietHoaDons { get; set; }

    public virtual DbSet<ChienDich> ChienDiches { get; set; }

    public virtual DbSet<DongGop> DongGops { get; set; }

    public virtual DbSet<HinhAnhChienDich> HinhAnhChienDiches { get; set; }

    public virtual DbSet<HinhAnhSanPham> HinhAnhSanPhams { get; set; }

    public virtual DbSet<HoaDon> HoaDons { get; set; }

    public virtual DbSet<LoaiSanPham> LoaiSanPhams { get; set; }

    public virtual DbSet<NguoiDung> NguoiDungs { get; set; }

    public virtual DbSet<SanPham> SanPhams { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=.\\SQLEXPRESS;Initial Catalog=SmartCharityShopDB;Integrated Security=True;Trust Server Certificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ChiTietHoaDon>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__ChiTietH__3214EC072576A2ED");

            entity.ToTable("ChiTietHoaDon");

            entity.Property(e => e.Gia).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.HoaDon).WithMany(p => p.ChiTietHoaDons)
                .HasForeignKey(d => d.HoaDonId)
                .HasConstraintName("FK__ChiTietHo__HoaDo__59FA5E80");

            entity.HasOne(d => d.SanPham).WithMany(p => p.ChiTietHoaDons)
                .HasForeignKey(d => d.SanPhamId)
                .HasConstraintName("FK__ChiTietHo__SanPh__5AEE82B9");
        });

        modelBuilder.Entity<ChienDich>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__ChienDic__3214EC078D4283E6");

            entity.ToTable("ChienDich");

            entity.Property(e => e.DiaDiem).HasMaxLength(255);
            entity.Property(e => e.HinhAnhChinh).HasMaxLength(255);
            entity.Property(e => e.MucTieu).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NgayBatDau)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.NgayKetThuc).HasColumnType("datetime");
            entity.Property(e => e.SoTienHienTai).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TenChienDich).HasMaxLength(200);
            entity.Property(e => e.TrangThai)
                .HasMaxLength(20)
                .HasDefaultValue("Đang diễn ra");

            entity.HasOne(d => d.NguoiTao).WithMany(p => p.ChienDiches)
                .HasForeignKey(d => d.NguoiTaoId)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK__ChienDich__Nguoi__4CA06362");
        });

        modelBuilder.Entity<DongGop>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DongGop__3214EC07808F372A");

            entity.ToTable("DongGop");

            entity.Property(e => e.LoaiNguon)
                .HasMaxLength(50)
                .HasDefaultValue("HoaDon");
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.SoTien).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.ChienDich).WithMany(p => p.DongGops)
                .HasForeignKey(d => d.ChienDichId)
                .HasConstraintName("FK__DongGop__ChienDi__60A75C0F");

            entity.HasOne(d => d.NguoiDung).WithMany(p => p.DongGops)
                .HasForeignKey(d => d.NguoiDungId)
                .HasConstraintName("FK__DongGop__NguoiDu__5FB337D6");
        });

        modelBuilder.Entity<HinhAnhChienDich>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HinhAnhC__3214EC076229A536");

            entity.ToTable("HinhAnhChienDich");

            entity.Property(e => e.IsChinh).HasDefaultValue(false);
            entity.Property(e => e.Url).HasMaxLength(255);

            entity.HasOne(d => d.ChienDich).WithMany(p => p.HinhAnhChienDiches)
                .HasForeignKey(d => d.ChienDichId)
                .HasConstraintName("FK__HinhAnhCh__Chien__5070F446");
        });

        modelBuilder.Entity<HinhAnhSanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HinhAnhS__3214EC078FF2CAAE");

            entity.ToTable("HinhAnhSanPham");

            entity.Property(e => e.IsChinh).HasDefaultValue(false);
            entity.Property(e => e.Url).HasMaxLength(255);

            entity.HasOne(d => d.SanPham).WithMany(p => p.HinhAnhSanPhams)
                .HasForeignKey(d => d.SanPhamId)
                .HasConstraintName("FK__HinhAnhSa__SanPh__45F365D3");
        });

        modelBuilder.Entity<HoaDon>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HoaDon__3214EC076F248DE5");

            entity.ToTable("HoaDon");

            entity.Property(e => e.LoaiThanhToan)
                .HasMaxLength(50)
                .HasDefaultValue("COD");
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TienDonate).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TongTien).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrangThaiThanhToan)
                .HasMaxLength(20)
                .HasDefaultValue("Pending");

            entity.HasOne(d => d.ChienDich).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.ChienDichId)
                .HasConstraintName("FK__HoaDon__ChienDic__571DF1D5");

            entity.HasOne(d => d.NguoiDung).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.NguoiDungId)
                .HasConstraintName("FK__HoaDon__NguoiDun__5629CD9C");
        });

        modelBuilder.Entity<LoaiSanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__LoaiSanP__3214EC072FAB1607");

            entity.ToTable("LoaiSanPham");

            entity.Property(e => e.TenLoai).HasMaxLength(100);
        });

        modelBuilder.Entity<NguoiDung>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__NguoiDun__3214EC079371BBBB");

            entity.ToTable("NguoiDung");

            entity.HasIndex(e => e.Email, "UQ__NguoiDun__A9D10534ABBD8301").IsUnique();

            entity.Property(e => e.AvatarUrl).HasMaxLength(255);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.GoogleId).HasMaxLength(100);
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.KieuDangNhap)
                .HasMaxLength(20)
                .HasDefaultValue("Local");
            entity.Property(e => e.MatKhau).HasMaxLength(255);
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TrangThai).HasDefaultValue(true);
            entity.Property(e => e.VaiTro)
                .HasMaxLength(20)
                .HasDefaultValue("User");
        });

        modelBuilder.Entity<SanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SanPham__3214EC07A83B3403");

            entity.ToTable("SanPham");

            entity.Property(e => e.AnhChinh).HasMaxLength(255);
            entity.Property(e => e.Gia).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TenSanPham).HasMaxLength(150);

            entity.HasOne(d => d.Loai).WithMany(p => p.SanPhams)
                .HasForeignKey(d => d.LoaiId)
                .HasConstraintName("FK__SanPham__LoaiId__4222D4EF");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
