using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("ChienDich")]
public partial class ChienDich
{
    [Key]
    public int Id { get; set; }

    [StringLength(200)]
    public string TenChienDich { get; set; } = null!;

    public string? MoTa { get; set; }

    [StringLength(255)]
    public string? HinhAnhChinh { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal MucTieu { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal SoTienHienTai { get; set; }

    [StringLength(20)]
    public string? TrangThai { get; set; }

    [StringLength(255)]
    public string? DiaDiem { get; set; }

    public int? NguoiTaoId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayBatDau { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayKetThuc { get; set; }

    [InverseProperty("ChienDich")]
    public virtual ICollection<Donation> Donations { get; set; } = new List<Donation>();

    [InverseProperty("ChienDich")]
    public virtual ICollection<DongGop> DongGops { get; set; } = new List<DongGop>();

    [InverseProperty("ChienDich")]
    public virtual ICollection<HinhAnhChienDich> HinhAnhChienDiches { get; set; } = new List<HinhAnhChienDich>();

    [ForeignKey("NguoiTaoId")]
    [InverseProperty("ChienDiches")]
    public virtual NguoiDung? NguoiTao { get; set; }
}
