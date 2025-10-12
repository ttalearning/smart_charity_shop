namespace SmartCharityAPI.DTOs
{
    public class DongGopDTO
    {
        public int Id { get; set; }
        public int NguoiDungId { get; set; }
        public string TenNguoiDung { get; set; } = "";
        public int ChienDichId { get; set; }
        public string TenChienDich { get; set; } = "";

        public string? LoiNhan { get; set; }

        public decimal SoTien { get; set; }
        public string LoaiNguon { get; set; } = "";
        public DateTime NgayTao { get; set; }
    }

    public class CreateDongGopDTO
    {
        public int ChienDichId { get; set; }
        public decimal SoTien { get; set; }
        public string? LoaiNguon { get; set; }
        public string? LoiNhan { get; set; }

    }

    public class TopDongGopDTO
    {
        public int NguoiDungId { get; set; }
        public string TenNguoiDung { get; set; } = "";
        public string? AvatarUrl { get; set; }
        public decimal TongTien { get; set; }
    }
}
