using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("Donation")]
public partial class Donation
{
    [Key]
    public int Id { get; set; }

    public int NguoiDungId { get; set; }

    public int ChienDichId { get; set; }

    public int Diem { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal GiaTriTien { get; set; }

    [StringLength(20)]
    public string? Source { get; set; }

    public DateTime? CreatedAt { get; set; }

    [ForeignKey("ChienDichId")]
    [InverseProperty("Donations")]
    public virtual ChienDich ChienDich { get; set; } = null!;

    [ForeignKey("NguoiDungId")]
    [InverseProperty("Donations")]
    public virtual NguoiDung NguoiDung { get; set; } = null!;
}
