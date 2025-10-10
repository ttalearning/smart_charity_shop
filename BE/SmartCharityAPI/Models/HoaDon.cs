using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("HoaDon")]
public partial class HoaDon
{
    [Key]
    public int Id { get; set; }

    public int NguoiDungId { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TongTienHang { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal PhiShip { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal GiamGia { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Thue { get; set; }

    [Column(TypeName = "decimal(21, 2)")]
    public decimal? TongThanhToan { get; set; }

    [StringLength(50)]
    public string? LoaiThanhToan { get; set; }

    [StringLength(20)]
    public string? TrangThaiThanhToan { get; set; }

    [StringLength(20)]
    public string? TrangThaiDonHang { get; set; }

    [StringLength(120)]
    public string? TenNguoiNhan { get; set; }

    [StringLength(20)]
    public string? SoDienThoai { get; set; }

    [StringLength(300)]
    public string? DiaChiNhan { get; set; }

    [StringLength(500)]
    public string? GhiChu { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    [InverseProperty("HoaDon")]
    public virtual ICollection<ChiTietHoaDon> ChiTietHoaDons { get; set; } = new List<ChiTietHoaDon>();

    [ForeignKey("NguoiDungId")]
    [InverseProperty("HoaDons")]
    public virtual NguoiDung NguoiDung { get; set; } = null!;

    [InverseProperty("HoaDon")]
    public virtual ICollection<PaymentTransaction> PaymentTransactions { get; set; } = new List<PaymentTransaction>();
}
