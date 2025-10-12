using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Repositories
{
    public class HoaDonRepository : IHoaDonRepository
    {
        private readonly SmartCharityContext _context;

        public HoaDonRepository(SmartCharityContext context)
        {
            _context = context;
        }

        public async Task<HoaDonResponseDTO> CreateAsync(int userId, HoaDonRequestDTO dto)
        {
            decimal tongTienHang = dto.ChiTiet.Sum(c => c.SoLuong * c.GiaLucBan);
            decimal tienDonate = tongTienHang * 0.1m; // 10% tiền quyên góp

            var hoaDon = new HoaDon
            {
                NguoiDungId = userId,
                TongTienHang = tongTienHang,
                PhiShip = 0,
                GiamGia = 0,
                Thue = 0,
                LoaiThanhToan = dto.LoaiThanhToan,
                TrangThaiThanhToan = dto.TrangThaiThanhToan,
                TrangThaiDonHang = "Pending",
                TenNguoiNhan = dto.TenNguoiNhan,
                SoDienThoai = dto.SoDienThoai,
                DiaChiNhan = dto.DiaChiNhan,
                GhiChu = dto.GhiChu,
                CreatedAt = DateTime.UtcNow
            };

            _context.HoaDons.Add(hoaDon);
            await _context.SaveChangesAsync();

            foreach (var item in dto.ChiTiet)
            {
                var sanPham = await _context.SanPhams.FindAsync(item.SanPhamId);

                _context.ChiTietHoaDons.Add(new ChiTietHoaDon
                {
                    HoaDonId = hoaDon.Id,
                    SanPhamId = item.SanPhamId,
                    TenSanPham = sanPham?.TenSanPham,
                    GiaLucBan = item.GiaLucBan,
                    SoLuong = item.SoLuong
                });
            }

            await _context.SaveChangesAsync();

            // ✅ Nếu là thanh toán MOMO thành công => tự tạo bản ghi Đóng Góp
            if (dto.TrangThaiThanhToan?.Equals("SUCCESS", StringComparison.OrdinalIgnoreCase) == true
                && dto.ChienDichId != null)
            {
                var dongGop = new DongGop
                {
                    NguoiDungId = userId,
                    ChienDichId = dto.ChienDichId.Value,
                    SoTien = tienDonate,
                    LoaiNguon = "Tự động từ MoMo",
                    NgayTao = DateTime.UtcNow
                };

                _context.DongGops.Add(dongGop);
                await _context.SaveChangesAsync();
            }

            return new HoaDonResponseDTO
            {
                Id = hoaDon.Id,
                TongTienHang = tongTienHang,
                TienDonate = tienDonate,
                LoaiThanhToan = hoaDon.LoaiThanhToan,
                TrangThaiThanhToan = hoaDon.TrangThaiThanhToan,
                CreatedAt = hoaDon.CreatedAt ?? DateTime.Now,
                ChiTiet = dto.ChiTiet
            };
        }


        public async Task<IEnumerable<HoaDonResponseDTO>> GetByUserAsync(int userId)
        {
            var list = await _context.HoaDons
                .Where(h => h.NguoiDungId == userId)
                .OrderByDescending(h => h.CreatedAt)
                .Select(h => new HoaDonResponseDTO
                {
                    Id = h.Id,
                    TongTienHang = h.TongTienHang,
                    TienDonate = (decimal)(h.TongTienHang * 0.1m),
                    LoaiThanhToan = h.LoaiThanhToan,
                    TrangThaiThanhToan = h.TrangThaiThanhToan,
                    CreatedAt = h.CreatedAt ?? DateTime.Now,
                }).ToListAsync();

            return list;
        }

        public async Task<HoaDonResponseDTO?> GetByIdAsync(int id, int userId)
        {
            var h = await _context.HoaDons
                .Include(hd => hd.ChiTietHoaDons)
                .Where(hd => hd.Id == id && hd.NguoiDungId == userId)
                .FirstOrDefaultAsync();

            if (h == null) return null;

            return new HoaDonResponseDTO
            {
                Id = h.Id,
                TongTienHang = h.TongTienHang,
                TienDonate = (decimal)(h.TongTienHang * 0.1m),
                LoaiThanhToan = h.LoaiThanhToan,
                TrangThaiThanhToan = h.TrangThaiThanhToan,

                CreatedAt = h.CreatedAt ?? DateTime.Now,
                ChiTiet = h.ChiTietHoaDons.Select(c => new ChiTietHoaDonDTO
                {
                    SanPhamId = c.SanPhamId,
                    SoLuong = c.SoLuong,
                    GiaLucBan = c.GiaLucBan
                }).ToList()
            };
        }
    }
}
