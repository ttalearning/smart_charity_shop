namespace SmartCharityAPI.DTOs
{
    public class HoaDonRequestDTO
    {
        public int ChienDichId { get; set; }
        public List<ChiTietHoaDonDTO> ChiTiet { get; set; } = new();
        public string LoaiThanhToan { get; set; } = "COD";
    }

    public class ChiTietHoaDonDTO
    {
        public int SanPhamId { get; set; }
        public int SoLuong { get; set; }
        public decimal Gia { get; set; }
    }

    public class HoaDonResponseDTO
    {
        public int Id { get; set; }
        public decimal TongTien { get; set; }
        public decimal TienDonate { get; set; }
        public string LoaiThanhToan { get; set; } = "";
        public string TrangThaiThanhToan { get; set; } = "";
        public string? TenChienDich { get; set; }
        public DateTime NgayTao { get; set; }
        public List<ChiTietHoaDonDTO> ChiTiet { get; set; } = new();
    }
}
