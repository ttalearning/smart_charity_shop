using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("ChiTietHoaDon")]
[Index("HoaDonId", Name = "IX_ChiTietHoaDon_HoaDonId")]
[Index("SanPhamId", Name = "IX_ChiTietHoaDon_SanPhamId")]
public partial class ChiTietHoaDon
{
    [Key]
    public int Id { get; set; }

    public int HoaDonId { get; set; }

    public int SanPhamId { get; set; }

    [StringLength(255)]
    public string? TenSanPham { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal GiaLucBan { get; set; }

    public int SoLuong { get; set; }

    [Column(TypeName = "decimal(29, 2)")]
    public decimal? ThanhTien { get; set; }

    [ForeignKey("HoaDonId")]
    [InverseProperty("ChiTietHoaDons")]
    public virtual HoaDon HoaDon { get; set; } = null!;

    [ForeignKey("SanPhamId")]
    [InverseProperty("ChiTietHoaDons")]
    public virtual SanPham SanPham { get; set; } = null!;
}
