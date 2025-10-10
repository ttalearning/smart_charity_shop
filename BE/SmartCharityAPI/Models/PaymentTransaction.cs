using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Models;

[Table("PaymentTransaction")]
[Index("HoaDonId", Name = "IX_Payment_Order")]
[Index("Provider", "CreatedAt", Name = "IX_Payment_Provider", IsDescending = new[] { false, true })]
public partial class PaymentTransaction
{
    [Key]
    public int Id { get; set; }

    public int HoaDonId { get; set; }

    [StringLength(20)]
    public string Provider { get; set; } = null!;

    [StringLength(100)]
    public string? ProviderTransId { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal Amount { get; set; }

    [StringLength(10)]
    public string? Currency { get; set; }

    [StringLength(20)]
    public string Status { get; set; } = null!;

    public string? Payload { get; set; }

    public DateTime? CreatedAt { get; set; }

    [ForeignKey("HoaDonId")]
    [InverseProperty("PaymentTransactions")]
    public virtual HoaDon HoaDon { get; set; } = null!;
}
