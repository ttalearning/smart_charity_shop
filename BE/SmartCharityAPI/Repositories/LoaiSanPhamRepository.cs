using Microsoft.EntityFrameworkCore;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using System;

namespace SmartCharityAPI.Repositories
{
    public class LoaiSanPhamRepository : ILoaiSanPhamRepository
    {
        private readonly SmartCharityContext _ctx;
        public LoaiSanPhamRepository(SmartCharityContext ctx) { _ctx = ctx; }

        public async Task<IEnumerable<LoaiSanPhamDTO>> GetAllAsync()
        {
            return await _ctx.LoaiSanPhams
                .Select(l => new LoaiSanPhamDTO
                {
                    Id = l.Id,
                    TenLoai = l.TenLoai,
                    SoSanPham = l.SanPhams.Count()
                })
                .OrderBy(x => x.TenLoai)
                .ToListAsync();
        }

        public async Task<LoaiSanPhamDTO?> GetByIdAsync(int id)
        {
            return await _ctx.LoaiSanPhams
                .Where(l => l.Id == id)
                .Select(l => new LoaiSanPhamDTO
                {
                    Id = l.Id,
                    TenLoai = l.TenLoai,
                    SoSanPham = l.SanPhams.Count()
                })
                .FirstOrDefaultAsync();
        }

        public async Task<LoaiSanPhamDTO> CreateAsync(CreateLoaiSanPhamDTO dto)
        {
            var entity = new LoaiSanPham
            {
                TenLoai = dto.TenLoai.Trim(),
            };
            _ctx.LoaiSanPhams.Add(entity);
            await _ctx.SaveChangesAsync();

            return new LoaiSanPhamDTO
            {
                Id = entity.Id,
                TenLoai = entity.TenLoai,
                SoSanPham = 0
            };
        }

        public async Task<bool> UpdateAsync(int id, CreateLoaiSanPhamDTO dto)
        {
            var entity = await _ctx.LoaiSanPhams.FindAsync(id);
            if (entity == null) return false;

            entity.TenLoai = dto.TenLoai.Trim();

            await _ctx.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var entity = await _ctx.LoaiSanPhams
                .Include(l => l.SanPhams)
                .FirstOrDefaultAsync(l => l.Id == id);
            if (entity == null) return false;

            if (entity.SanPhams.Any())
                throw new InvalidOperationException("Loại đang có sản phẩm, không thể xoá.");

            _ctx.LoaiSanPhams.Remove(entity);
            await _ctx.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ExistsByNameAsync(string tenLoai, int? excludeId = null)
        {
            tenLoai = tenLoai.Trim();
            return await _ctx.LoaiSanPhams
                .AnyAsync(l => l.TenLoai == tenLoai && (excludeId == null || l.Id != excludeId));
        }
    }
}
