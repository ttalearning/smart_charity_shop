namespace SmartCharityAPI.DTOs
{
    public class UserDTO
    {
        public int Id { get; set; }
        public string HoTen { get; set; } = "";
        public string Email { get; set; } = "";
        public string VaiTro { get; set; } = "";
        public bool TrangThai { get; set; } = true;
        public string? AvatarUrl { get; set; }
        public DateTime NgayTao { get; set; }
        public string? KieuDangNhap { get; set; }
    }

    public class UpdateRoleDTO
    {
        public string VaiTro { get; set; } = "User"; // User | Admin
    }

    public class UpdateStatusDTO
    {
        public bool TrangThai { get; set; }
    }
}
