using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Repositories
{
    public class SanPhamRepository : ISanPhamRepository
    {
        private readonly SmartCharityContext _context;

        public SanPhamRepository(SmartCharityContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<SanPhamDTO>> GetAllAsync()
        {
            return await _context.SanPhams
                .Include(x => x.Loai)
                .Select(x => new SanPhamDTO
                {
                    Id = x.Id,
                    TenSanPham = x.TenSanPham,
                    Gia = x.Gia,
                    MoTa = x.MoTa,
                    AnhChinh = x.AnhChinh,
                    TenLoai = x.Loai != null ? x.Loai.TenLoai : null
                }).ToListAsync();
        }

        public async Task<SanPhamDTO?> GetByIdAsync(int id)
        {
            return await _context.SanPhams
                .Include(x => x.Loai)
                .Where(x => x.Id == id)
                .Select(x => new SanPhamDTO
                {
                    Id = x.Id,
                    TenSanPham = x.TenSanPham,
                    Gia = x.Gia,
                    MoTa = x.MoTa,
                    AnhChinh = x.AnhChinh,
                    TenLoai = x.Loai != null ? x.Loai.TenLoai : null
                }).FirstOrDefaultAsync();
        }

        public async Task<SanPhamDTO> CreateAsync(SanPhamDTO dto)
        {
            var entity = new SanPham
            {
                TenSanPham = dto.TenSanPham,
                Gia = dto.Gia,
                MoTa = dto.MoTa,
                AnhChinh = dto.AnhChinh,
                LoaiId = dto.LoaiId
            };
            _context.SanPhams.Add(entity);
            await _context.SaveChangesAsync();

            dto.Id = entity.Id;
            return dto;
        }

        public async Task<bool> UpdateAsync(int id, SanPhamDTO dto)
        {
            var sp = await _context.SanPhams.FindAsync(id);
            if (sp == null) return false;

            sp.TenSanPham = dto.TenSanPham;
            sp.Gia = dto.Gia;
            sp.MoTa = dto.MoTa;
            sp.AnhChinh = dto.AnhChinh;
            sp.LoaiId = dto.LoaiId;

            _context.SanPhams.Update(sp);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var sp = await _context.SanPhams.FindAsync(id);
            if (sp == null) return false;
            _context.SanPhams.Remove(sp);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
