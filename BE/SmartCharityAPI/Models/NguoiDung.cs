using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("NguoiDung")]
[Index("Email", Name = "UQ__NguoiDun__A9D10534ABBD8301", IsUnique = true)]
public partial class NguoiDung
{
    [Key]
    public int Id { get; set; }

    [StringLength(100)]
    public string HoTen { get; set; } = null!;

    [StringLength(100)]
    public string Email { get; set; } = null!;

    [StringLength(255)]
    public string? MatKhau { get; set; }

    [StringLength(20)]
    public string? VaiTro { get; set; }

    [StringLength(100)]
    public string? GoogleId { get; set; }

    [StringLength(255)]
    public string? AvatarUrl { get; set; }

    [StringLength(20)]
    public string? KieuDangNhap { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? NgayTao { get; set; }

    public bool? TrangThai { get; set; }

    [InverseProperty("NguoiTao")]
    public virtual ICollection<ChienDich> ChienDiches { get; set; } = new List<ChienDich>();

    [InverseProperty("NguoiDung")]
    public virtual ICollection<Donation> Donations { get; set; } = new List<Donation>();

    [InverseProperty("NguoiDung")]
    public virtual ICollection<DongGop> DongGops { get; set; } = new List<DongGop>();

    [InverseProperty("NguoiDung")]
    public virtual ICollection<HoaDon> HoaDons { get; set; } = new List<HoaDon>();
}
