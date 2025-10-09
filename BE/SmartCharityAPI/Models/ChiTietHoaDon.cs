using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("ChiTietHoaDon")]
public partial class ChiTietHoaDon
{
    [Key]
    public int Id { get; set; }

    public int HoaDonId { get; set; }

    public int SanPhamId { get; set; }

    public int SoLuong { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Gia { get; set; }

    [ForeignKey("HoaDonId")]
    [InverseProperty("ChiTietHoaDons")]
    public virtual HoaDon HoaDon { get; set; } = null!;

    [ForeignKey("SanPhamId")]
    [InverseProperty("ChiTietHoaDons")]
    public virtual SanPham SanPham { get; set; } = null!;
}
