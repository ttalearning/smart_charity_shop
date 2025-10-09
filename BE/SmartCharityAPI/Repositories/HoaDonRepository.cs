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
            
            decimal tongTien = dto.ChiTiet.Sum(c => c.SoLuong * c.Gia);
            decimal tienDonate = tongTien * 0.1m;

            
            var hoaDon = new HoaDon
            {
                NguoiDungId = userId,
                ChienDichId = dto.ChienDichId,
                TongTien = tongTien,
                TienDonate = tienDonate,
                LoaiThanhToan = dto.LoaiThanhToan,
                TrangThaiThanhToan = "Success",
                NgayTao = DateTime.UtcNow
            };
            _context.HoaDons.Add(hoaDon);
            await _context.SaveChangesAsync();

            
            foreach (var item in dto.ChiTiet)
            {
                _context.ChiTietHoaDons.Add(new ChiTietHoaDon
                {
                    HoaDonId = hoaDon.Id,
                    SanPhamId = item.SanPhamId,
                    SoLuong = item.SoLuong,
                    Gia = item.Gia
                });
            }
            await _context.SaveChangesAsync();

            
            var dongGop = new DongGop
            {
                NguoiDungId = userId,
                ChienDichId = dto.ChienDichId,
                SoTien = tienDonate,
                LoaiNguon = "HoaDon",
                NgayTao = DateTime.UtcNow
            };
            _context.DongGops.Add(dongGop);

            
            var cd = await _context.ChienDiches.FindAsync(dto.ChienDichId);
            if (cd != null)
                cd.SoTienHienTai += tienDonate;

            await _context.SaveChangesAsync();

            
            return new HoaDonResponseDTO
            {
                Id = hoaDon.Id,
                TongTien = tongTien,
                TienDonate = tienDonate,
                LoaiThanhToan = hoaDon.LoaiThanhToan,
                TrangThaiThanhToan = hoaDon.TrangThaiThanhToan,
                TenChienDich = cd?.TenChienDich,
                NgayTao = hoaDon.NgayTao ?? DateTime.Now,

                ChiTiet = dto.ChiTiet
            };
        }

        public async Task<IEnumerable<HoaDonResponseDTO>> GetByUserAsync(int userId)
        {
            var list = await _context.HoaDons
                .Include(h => h.ChienDich)
                .Where(h => h.NguoiDungId == userId)
                .Select(h => new HoaDonResponseDTO
                {
                    Id = h.Id,
                    TongTien = h.TongTien,
                    TienDonate = h.TienDonate,
                    LoaiThanhToan = h.LoaiThanhToan,
                    TrangThaiThanhToan = h.TrangThaiThanhToan,
                    TenChienDich = h.ChienDich.TenChienDich,
                    NgayTao = h.NgayTao ?? DateTime.Now,

                }).ToListAsync();

            return list;
        }

        public async Task<HoaDonResponseDTO?> GetByIdAsync(int id, int userId)
        {
            return await _context.HoaDons
                .Include(h => h.ChienDich)
                .Where(h => h.Id == id && h.NguoiDungId == userId)
                .Select(h => new HoaDonResponseDTO
                {
                    Id = h.Id,
                    TongTien = h.TongTien,
                    TienDonate = h.TienDonate,
                    LoaiThanhToan = h.LoaiThanhToan,
                    TrangThaiThanhToan = h.TrangThaiThanhToan,
                    TenChienDich = h.ChienDich.TenChienDich,
                    NgayTao = h.NgayTao ?? DateTime.Now,

                }).FirstOrDefaultAsync();
        }
    }
}
