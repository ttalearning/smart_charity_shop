using Microsoft.EntityFrameworkCore;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;

namespace SmartCharityAPI.Repositories
{
    public class DongGopRepository : IDongGopRepository
    {
        private readonly SmartCharityContext _context;

        public DongGopRepository(SmartCharityContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<DongGopDTO>> GetAllAsync()
        {
            return await _context.DongGops
                .Include(d => d.NguoiDung)
                .Include(d => d.ChienDich)
                .OrderByDescending(d => d.NgayTao)
                .Select(d => new DongGopDTO
                {
                    Id = d.Id,
                    NguoiDungId = d.NguoiDungId,
                    TenNguoiDung = d.NguoiDung.HoTen,
                    ChienDichId = d.ChienDichId,
                    TenChienDich = d.ChienDich.TenChienDich,
                    SoTien = d.SoTien,
                    LoaiNguon = d.LoaiNguon,
                    NgayTao = d.NgayTao ?? DateTime.Now,
                }).ToListAsync();
        }
        public async Task<IEnumerable<DongGopDTO>> GetByCampaignAsync(int campaignId)
        {
            return await _context.DongGops
                .Include(d => d.NguoiDung)
                .Include(d => d.ChienDich)
                .Where(d => d.ChienDichId == campaignId)
                .OrderByDescending(d => d.NgayTao)
                .Select(d => new DongGopDTO
                {
                    Id = d.Id,
                    NguoiDungId = d.NguoiDungId,
                    TenNguoiDung = d.NguoiDung.HoTen,
                    ChienDichId = d.ChienDichId,
                    TenChienDich = d.ChienDich.TenChienDich ,
                    SoTien = d.SoTien,
                    LoaiNguon = d.LoaiNguon,
                    NgayTao = d.NgayTao ?? DateTime.Now,
                })
                .ToListAsync();
        }

        public async Task<IEnumerable<DongGopDTO>> GetByUserAsync(int userId)
        {
            return await _context.DongGops
                .Include(d => d.ChienDich)
                .Where(d => d.NguoiDungId == userId)
                .OrderByDescending(d => d.NgayTao)
                .Select(d => new DongGopDTO
                {
                    Id = d.Id,
                    NguoiDungId = d.NguoiDungId,
                    ChienDichId = d.ChienDichId,
                    TenChienDich = d.ChienDich.TenChienDich,
                    SoTien = d.SoTien,
                    LoiNhan = d.LoiNhan,
                    LoaiNguon = d.LoaiNguon,
                    NgayTao = d.NgayTao ?? DateTime.Now,
                }).ToListAsync();
        }

        public async Task<bool> CreateAsync(int userId, CreateDongGopDTO dto)
        {
            if (!await _context.ChienDiches.AnyAsync(c => c.Id == dto.ChienDichId))
                return false;

            var dongGop = new DongGop
            {
                NguoiDungId = userId,
                ChienDichId = dto.ChienDichId,
                SoTien = dto.SoTien,
                LoiNhan = dto.LoiNhan ?? "",
                LoaiNguon = "Trực tiếp",
                NgayTao = DateTime.UtcNow
            };

            _context.DongGops.Add(dongGop);

            var cd = await _context.ChienDiches.FindAsync(dto.ChienDichId);
            if (cd != null)
                cd.SoTienHienTai += dto.SoTien;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<TopDongGopDTO>> GetTopAsync(int limit = 10)
        {
            return await _context.DongGops
                .Include(d => d.NguoiDung)
                .GroupBy(d => new { d.NguoiDungId, d.NguoiDung.HoTen, d.NguoiDung.AvatarUrl })
                .Select(g => new TopDongGopDTO
                {
                    NguoiDungId = g.Key.NguoiDungId,
                    TenNguoiDung = g.Key.HoTen,
                    AvatarUrl = g.Key.AvatarUrl,
                    TongTien = g.Sum(x => x.SoTien)
                })
                .OrderByDescending(x => x.TongTien)
                .Take(limit)
                .ToListAsync();
        }
    }
}
