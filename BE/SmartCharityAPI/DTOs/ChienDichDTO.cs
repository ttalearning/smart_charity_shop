namespace SmartCharityAPI.DTOs
{
    public class ChienDichDTO
    {
        public int Id { get; set; }
        public string TenChienDich { get; set; } = "";
        public string? MoTa { get; set; }
        public string? HinhAnhChinh { get; set; }
        public decimal MucTieu { get; set; }
        public decimal SoTienHienTai { get; set; }
        public string TrangThai { get; set; } = "Đang diễn ra";
        public string? DiaDiem { get; set; }
        public DateTime? NgayBatDau { get; set; }
        public DateTime? NgayKetThuc { get; set; }
        public List<HinhAnhChienDichDTO>? HinhAnhs { get; set; }
    }

    public class CreateChienDichDTO
    {
        public string TenChienDich { get; set; } = "";
        public string? MoTa { get; set; }
        public string? HinhAnhChinh { get; set; }
        public decimal MucTieu { get; set; }
        public string? DiaDiem { get; set; }
        public DateTime? NgayBatDau { get; set; }
        public DateTime? NgayKetThuc { get; set; }

        public List<HinhAnhChienDichDTO>? HinhAnhs { get; set; }
    }
}
