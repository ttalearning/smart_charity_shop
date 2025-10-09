using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("LoaiSanPham")]
public partial class LoaiSanPham
{
    [Key]
    public int Id { get; set; }

    [StringLength(100)]
    public string TenLoai { get; set; } = null!;

    [InverseProperty("Loai")]
    public virtual ICollection<SanPham> SanPhams { get; set; } = new List<SanPham>();
}
