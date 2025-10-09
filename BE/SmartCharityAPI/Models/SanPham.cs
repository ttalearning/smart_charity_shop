using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("SanPham")]
public partial class SanPham
{
    [Key]
    public int Id { get; set; }

    [StringLength(150)]
    public string TenSanPham { get; set; } = null!;

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Gia { get; set; }

    public string? MoTa { get; set; }

    [StringLength(255)]
    public string? AnhChinh { get; set; }

    public int LoaiId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayTao { get; set; }

    [InverseProperty("SanPham")]
    public virtual ICollection<ChiTietHoaDon> ChiTietHoaDons { get; set; } = new List<ChiTietHoaDon>();

    [InverseProperty("SanPham")]
    public virtual ICollection<HinhAnhSanPham> HinhAnhSanPhams { get; set; } = new List<HinhAnhSanPham>();

    [ForeignKey("LoaiId")]
    [InverseProperty("SanPhams")]
    public virtual LoaiSanPham Loai { get; set; } = null!;
}
