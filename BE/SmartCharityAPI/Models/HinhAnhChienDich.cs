using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("HinhAnhChienDich")]
public partial class HinhAnhChienDich
{
    [Key]
    public int Id { get; set; }

    public int ChienDichId { get; set; }

    [StringLength(255)]
    public string Url { get; set; } = null!;

    public bool? IsChinh { get; set; }

    [ForeignKey("ChienDichId")]
    [InverseProperty("HinhAnhChienDiches")]
    public virtual ChienDich ChienDich { get; set; } = null!;
}
