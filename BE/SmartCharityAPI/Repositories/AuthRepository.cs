using SmartCharityAPI.DTOs;
using SmartCharityAPI.Helpers;
using SmartCharityAPI.Models;
using System.Text;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Repositories
{
    public class AuthRepository : IAuthRepository
    {
        private readonly SmartCharityContext _context;
        private readonly JwtHelper _jwt;

        public AuthRepository(SmartCharityContext context, IConfiguration config)
        {
            _context = context;
            _jwt = new JwtHelper(config);
        }

        private string HashPassword(string password)
        {
            using var sha256 = SHA256.Create();
            var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
            return Convert.ToBase64String(bytes);
        }

        private bool VerifyPassword(string password, string hashed)
        {
            return HashPassword(password) == hashed;
        }

        public async Task<AuthResponseDTO> RegisterAsync(RegisterDTO dto)
        {
            if (await _context.NguoiDungs.AnyAsync(u => u.Email == dto.Email))
                throw new Exception("Email đã được sử dụng.");

            var user = new NguoiDung
            {
                HoTen = dto.HoTen,
                Email = dto.Email,
                MatKhau = HashPassword(dto.MatKhau),
                VaiTro = "User",
                KieuDangNhap = "Local",
                NgayTao = DateTime.UtcNow
            };

            _context.NguoiDungs.Add(user);
            await _context.SaveChangesAsync();

            return new AuthResponseDTO
            {
                Token = _jwt.GenerateToken(user),
                HoTen = user.HoTen,
                Email = user.Email,
                VaiTro = user.VaiTro
            };
        }

        public async Task<AuthResponseDTO?> LoginAsync(LoginDTO dto)
        {
            var user = await _context.NguoiDungs
                .FirstOrDefaultAsync(u => u.Email == dto.Email);

            if (user == null)
                return null;

            if (user.KieuDangNhap == "Google")
            {
                if (string.IsNullOrEmpty(user.MatKhau))
                {
                    user.MatKhau = HashPassword(dto.MatKhau);
                    user.NgayTao = DateTime.UtcNow;
                    _context.NguoiDungs.Update(user);
                    await _context.SaveChangesAsync();
                }
                else
                {
                    if (!VerifyPassword(dto.MatKhau, user.MatKhau))
                        return null;
                }
            }
            else
            {
                if (!VerifyPassword(dto.MatKhau, user.MatKhau ?? ""))
                    return null;
            }

            return new AuthResponseDTO
            {
                Token = _jwt.GenerateToken(user),
                Id = user.Id,
                HoTen = user.HoTen,
                Email = user.Email,
                VaiTro = user.VaiTro,
                AvatarUrl = user.AvatarUrl
            };
        }


        public async Task<AuthResponseDTO> LoginGoogleAsync(GoogleLoginDTO dto)
        {
            var user = await _context.NguoiDungs.FirstOrDefaultAsync(u => u.GoogleId == dto.GoogleId);

            if (user == null)
            {
                user = await _context.NguoiDungs.FirstOrDefaultAsync(u => u.Email == dto.Email);

                if (user != null)
                {
                    user.GoogleId = dto.GoogleId;
                    user.AvatarUrl = dto.AvatarUrl;
                    user.NgayTao = DateTime.UtcNow;
                    _context.NguoiDungs.Update(user);
                }
                else
                {
                    user = new NguoiDung
                    {
                        HoTen = dto.HoTen,
                        Email = dto.Email,
                        GoogleId = dto.GoogleId,
                        AvatarUrl = dto.AvatarUrl,
                        VaiTro = "User",
                        KieuDangNhap = "Google",
                        NgayTao = DateTime.UtcNow
                    };
                    _context.NguoiDungs.Add(user);
                }

                await _context.SaveChangesAsync();
            }


            var token = _jwt.GenerateToken(user);

            return new AuthResponseDTO
            {
                Token = token,
                HoTen = user.HoTen,
                Email = user.Email,
                VaiTro = user.VaiTro,
                AvatarUrl = user.AvatarUrl
            };
        }

    }
}
