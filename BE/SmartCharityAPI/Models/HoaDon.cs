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

    public int ChienDichId { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TongTien { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TienDonate { get; set; }

    [StringLength(50)]
    public string? LoaiThanhToan { get; set; }

    [StringLength(20)]
    public string? TrangThaiThanhToan { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayTao { get; set; }

    [InverseProperty("HoaDon")]
    public virtual ICollection<ChiTietHoaDon> ChiTietHoaDons { get; set; } = new List<ChiTietHoaDon>();

    [ForeignKey("ChienDichId")]
    [InverseProperty("HoaDons")]
    public virtual ChienDich ChienDich { get; set; } = null!;

    [ForeignKey("NguoiDungId")]
    [InverseProperty("HoaDons")]
    public virtual NguoiDung NguoiDung { get; set; } = null!;
}
