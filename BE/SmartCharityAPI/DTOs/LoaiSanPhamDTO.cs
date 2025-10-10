namespace SmartCharityAPI.DTOs
{
    public class LoaiSanPhamDTO
    {
        public int Id { get; set; }
        public string TenLoai { get; set; } = "";
        public bool IsActive { get; set; } = true;
        public int SoSanPham { get; set; } = 0; // tiện cho list
    }

    public class CreateLoaiSanPhamDTO
    {
        public string TenLoai { get; set; } = "";
        public bool IsActive { get; set; } = true;
    }
}
