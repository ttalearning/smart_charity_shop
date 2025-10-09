namespace SmartCharityAPI.DTOs
{
    public class SanPhamDTO
    {
        public int Id { get; set; }
        public string TenSanPham { get; set; } = "";
        public decimal Gia { get; set; }
        public string? MoTa { get; set; }
        public string? AnhChinh { get; set; }
        public int LoaiId { get; set; }
        public string? TenLoai { get; set; }
    }
}
