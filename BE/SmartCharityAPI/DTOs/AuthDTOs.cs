namespace SmartCharityAPI.DTOs
{
    public class RegisterDTO
    {
        public string HoTen { get; set; } = "";
        public string Email { get; set; } = "";
        public string MatKhau { get; set; } = "";
    }

    public class LoginDTO
    {
        public string Email { get; set; } = "";
        public string MatKhau { get; set; } = "";
    }

    public class GoogleLoginDTO
    {
        public string GoogleId { get; set; } = "";
        public string Email { get; set; } = "";
        public string HoTen { get; set; } = "";
        public string AvatarUrl { get; set; } = "";
    }

    public class AuthResponseDTO
    {
        public int Id { get; set; }
        public string Token { get; set; } = "";
        public string HoTen { get; set; } = "";
        public string Email { get; set; } = "";
        public string VaiTro { get; set; } = "";
        public string? AvatarUrl { get; set; }
    }
}
