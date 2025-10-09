using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

public partial class SmartCharityContext : DbContext
{
    public SmartCharityContext()
    {
    }

    public SmartCharityContext(DbContextOptions<SmartCharityContext> options)
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

            entity.HasOne(d => d.HoaDon).WithMany(p => p.ChiTietHoaDons).HasConstraintName("FK__ChiTietHo__HoaDo__59FA5E80");

            entity.HasOne(d => d.SanPham).WithMany(p => p.ChiTietHoaDons).HasConstraintName("FK__ChiTietHo__SanPh__5AEE82B9");
        });

        modelBuilder.Entity<ChienDich>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__ChienDic__3214EC078D4283E6");

            entity.Property(e => e.NgayBatDau).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.TrangThai).HasDefaultValue("Đang diễn ra");

            entity.HasOne(d => d.NguoiTao).WithMany(p => p.ChienDiches)
                .OnDelete(DeleteBehavior.SetNull)
                .HasConstraintName("FK__ChienDich__Nguoi__4CA06362");
        });

        modelBuilder.Entity<DongGop>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DongGop__3214EC07808F372A");

            entity.Property(e => e.LoaiNguon).HasDefaultValue("HoaDon");
            entity.Property(e => e.NgayTao).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.ChienDich).WithMany(p => p.DongGops).HasConstraintName("FK__DongGop__ChienDi__60A75C0F");

            entity.HasOne(d => d.NguoiDung).WithMany(p => p.DongGops).HasConstraintName("FK__DongGop__NguoiDu__5FB337D6");
        });

        modelBuilder.Entity<HinhAnhChienDich>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HinhAnhC__3214EC076229A536");

            entity.Property(e => e.IsChinh).HasDefaultValue(false);

            entity.HasOne(d => d.ChienDich).WithMany(p => p.HinhAnhChienDiches).HasConstraintName("FK__HinhAnhCh__Chien__5070F446");
        });

        modelBuilder.Entity<HinhAnhSanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HinhAnhS__3214EC078FF2CAAE");

            entity.Property(e => e.IsChinh).HasDefaultValue(false);

            entity.HasOne(d => d.SanPham).WithMany(p => p.HinhAnhSanPhams).HasConstraintName("FK__HinhAnhSa__SanPh__45F365D3");
        });

        modelBuilder.Entity<HoaDon>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__HoaDon__3214EC076F248DE5");

            entity.Property(e => e.LoaiThanhToan).HasDefaultValue("COD");
            entity.Property(e => e.NgayTao).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.TrangThaiThanhToan).HasDefaultValue("Pending");

            entity.HasOne(d => d.ChienDich).WithMany(p => p.HoaDons).HasConstraintName("FK__HoaDon__ChienDic__571DF1D5");

            entity.HasOne(d => d.NguoiDung).WithMany(p => p.HoaDons).HasConstraintName("FK__HoaDon__NguoiDun__5629CD9C");
        });

        modelBuilder.Entity<LoaiSanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__LoaiSanP__3214EC072FAB1607");
        });

        modelBuilder.Entity<NguoiDung>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__NguoiDun__3214EC079371BBBB");

            entity.Property(e => e.KieuDangNhap).HasDefaultValue("Local");
            entity.Property(e => e.NgayTao).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.TrangThai).HasDefaultValue(true);
            entity.Property(e => e.VaiTro).HasDefaultValue("User");
        });

        modelBuilder.Entity<SanPham>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__SanPham__3214EC07A83B3403");

            entity.Property(e => e.NgayTao).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.Loai).WithMany(p => p.SanPhams).HasConstraintName("FK__SanPham__LoaiId__4222D4EF");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
