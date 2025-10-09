namespace SmartCharityAPI.DTOs
{
    public class SummaryDTO
    {
        public decimal TongDoanhThu { get; set; }
        public decimal TongDonate { get; set; }
        public int TongHoaDon { get; set; }
        public int TongChienDich { get; set; }
        public decimal TiLeDonate { get; set; } // TongDonate / TongDoanhThu
    }

    public class RevenuePointDTO
    {
        public int Thang { get; set; }  // 1..12
        public decimal DoanhThu { get; set; }
        public decimal Donate { get; set; }
        public int SoHoaDon { get; set; }
    }

    public class TopCampaignDTO
    {
        public int ChienDichId { get; set; }
        public string TenChienDich { get; set; } = "";
        public string? HinhAnhChinh { get; set; }
        public decimal TongDonate { get; set; }
        public decimal MucTieu { get; set; }
        public decimal SoTienHienTai { get; set; }
    }

    public class TopDonorDTO
    {
        public int NguoiDungId { get; set; }
        public string TenNguoiDung { get; set; } = "";
        public string? AvatarUrl { get; set; }
        public decimal TongDonate { get; set; }
    }

    public class RecentOrderDTO
    {
        public int Id { get; set; }
        public DateTime NgayTao { get; set; }
        public decimal TongTien { get; set; }
        public decimal TienDonate { get; set; }
        public string LoaiThanhToan { get; set; } = "";
        public string TrangThaiThanhToan { get; set; } = "";
        public string TenChienDich { get; set; } = "";
        public string TenKhach { get; set; } = "";
    }
}
