using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("DongGop")]
public partial class DongGop
{
    [Key]
    public int Id { get; set; }

    public int NguoiDungId { get; set; }

    public int ChienDichId { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal SoTien { get; set; }

    [StringLength(50)]
    public string? LoaiNguon { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayTao { get; set; }

    [StringLength(200)]
    public string? LoiNhan { get; set; }

    [ForeignKey("ChienDichId")]
    [InverseProperty("DongGops")]
    public virtual ChienDich ChienDich { get; set; } = null!;

    [ForeignKey("NguoiDungId")]
    [InverseProperty("DongGops")]
    public virtual NguoiDung NguoiDung { get; set; } = null!;
}
