using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("HinhAnhSanPham")]
public partial class HinhAnhSanPham
{
    [Key]
    public int Id { get; set; }

    public int SanPhamId { get; set; }

    [StringLength(255)]
    public string Url { get; set; } = null!;

    public bool? IsChinh { get; set; }

    [ForeignKey("SanPhamId")]
    [InverseProperty("HinhAnhSanPhams")]
    public virtual SanPham SanPham { get; set; } = null!;
}
