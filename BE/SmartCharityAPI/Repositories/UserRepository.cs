using Microsoft.EntityFrameworkCore;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Interfaces;
using SmartCharityAPI.Models;

namespace SmartCharityAPI.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly SmartCharityContext _context;

        public UserRepository(SmartCharityContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<UserDTO>> GetAllAsync()
        {
            return await _context.NguoiDungs
                .OrderByDescending(u => u.NgayTao)
                .Select(u => new UserDTO
                {
                    Id = u.Id,
                    HoTen = u.HoTen,
                    Email = u.Email,
                    VaiTro = u.VaiTro,
                    TrangThai = u.TrangThai ?? true,
                    AvatarUrl = u.AvatarUrl,
                    KieuDangNhap = u.KieuDangNhap,
                    NgayTao = u.NgayTao ?? DateTime.Now,
                }).ToListAsync();
        }

        public async Task<UserDTO?> GetByIdAsync(int id)
        {
            var u = await _context.NguoiDungs.FindAsync(id);
            if (u == null) return null;

            return new UserDTO
            {
                Id = u.Id,
                HoTen = u.HoTen,
                Email = u.Email,
                VaiTro = u.VaiTro,
                TrangThai = u.TrangThai ?? true,
                AvatarUrl = u.AvatarUrl,
                KieuDangNhap = u.KieuDangNhap,
                NgayTao = u.NgayTao ?? DateTime.Now,
            };
        }

        public async Task<bool> UpdateRoleAsync(int id, string role)
        {
            var u = await _context.NguoiDungs.FindAsync(id);
            if (u == null) return false;

            u.VaiTro = role;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateStatusAsync(int id, bool status)
        {
            var u = await _context.NguoiDungs.FindAsync(id);
            if (u == null) return false;

            u.TrangThai = status;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<UserDTO?> GetCurrentUserAsync(int userId)
        {
            var u = await _context.NguoiDungs.FindAsync(userId);
            if (u == null) return null;

            return new UserDTO
            {
                Id = u.Id,
                HoTen = u.HoTen,
                Email = u.Email,
                VaiTro = u.VaiTro,
                TrangThai = u.TrangThai ?? true,
                AvatarUrl = u.AvatarUrl,
                KieuDangNhap = u.KieuDangNhap,
                NgayTao = u.NgayTao ?? DateTime.Now,
            };
        }
    }
}
