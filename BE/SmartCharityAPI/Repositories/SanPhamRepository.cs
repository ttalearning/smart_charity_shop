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
                .Include(x => x.HinhAnhSanPhams)
                .Select(x => new SanPhamDTO
                {
                    Id = x.Id,
                    TenSanPham = x.TenSanPham,
                    Gia = x.Gia,
                    MoTa = x.MoTa,
                    AnhChinh = x.AnhChinh,
                    LoaiId = x.LoaiId,
                    TenLoai = x.Loai != null ? x.Loai.TenLoai : null,
                    HinhAnhs = x.HinhAnhSanPhams
                        .Select(h => new HinhAnhSanPhamDTO
                        {
                            Id = h.Id,
                            Url = h.Url,
                            SanPhamId = h.SanPhamId,
                            IsChinh = h.IsChinh ?? false
                        })
                        .ToList()
                })
                .ToListAsync();
        }

        public async Task<IEnumerable<SanPhamDTO>> GetByCategory(int categoryId)
        {
            return await _context.SanPhams
                .Include(x => x.Loai)
                .Where(x => x.LoaiId == categoryId)
                .Select(x => new SanPhamDTO
                {
                    Id = x.Id,
                    TenSanPham = x.TenSanPham,
                    Gia = x.Gia,
                    MoTa = x.MoTa,
                    AnhChinh = x.AnhChinh,
                    LoaiId = x.LoaiId,
                    TenLoai = x.Loai != null ? x.Loai.TenLoai : null
                }).ToListAsync();
        }

        public async Task<SanPhamDTO?> GetByIdAsync(int id)
        {
            return await _context.SanPhams
                .Include(x => x.Loai)
                .Include(x => x.HinhAnhSanPhams)
                .Where(x => x.Id == id)
                .Select(x => new SanPhamDTO
                {
                    Id = x.Id,
                    TenSanPham = x.TenSanPham,
                    Gia = x.Gia,
                    MoTa = x.MoTa,
                    AnhChinh = x.AnhChinh,
                    LoaiId = x.LoaiId,
                    TenLoai = x.Loai != null ? x.Loai.TenLoai : null,
                    HinhAnhs = x.HinhAnhSanPhams
                        .Select(h => new HinhAnhSanPhamDTO
                        {
                            Id = h.Id,
                            Url = h.Url,
                            SanPhamId = h.SanPhamId,
                            IsChinh = h.IsChinh ?? false
                        })
                        .ToList()
                })
                .FirstOrDefaultAsync();
        }

        // 🟢 CREATE: Thêm sản phẩm và danh sách ảnh liên quan
        public async Task<SanPhamDTO> CreateAsync(SanPhamDTO dto)
        {
            var entity = new SanPham
            {
                TenSanPham = dto.TenSanPham,
                Gia = dto.Gia,
                MoTa = dto.MoTa,
                AnhChinh = dto.AnhChinh,
                LoaiId = dto.LoaiId,
                HinhAnhSanPhams = dto.HinhAnhs?.Select(h => new HinhAnhSanPham
                {
                    Url = h.Url,
                    IsChinh = h.IsChinh
                }).ToList() ?? new List<HinhAnhSanPham>()
            };

            _context.SanPhams.Add(entity);
            await _context.SaveChangesAsync();

            dto.Id = entity.Id;
            // Gán lại Id cho các ảnh (EF tự sinh sau khi SaveChanges)
            dto.HinhAnhs = entity.HinhAnhSanPhams.Select(h => new HinhAnhSanPhamDTO
            {
                Id = h.Id,
                Url = h.Url,
                SanPhamId = h.SanPhamId,
                IsChinh = h.IsChinh ?? false
            }).ToList();

            return dto;
        }

        // 🟡 UPDATE: Cập nhật sản phẩm và thay thế danh sách ảnh
        public async Task<bool> UpdateAsync(int id, SanPhamDTO dto)
        {
            var sp = await _context.SanPhams
                .Include(x => x.HinhAnhSanPhams)
                .FirstOrDefaultAsync(x => x.Id == id);

            if (sp == null) return false;

            // Cập nhật thông tin cơ bản
            sp.TenSanPham = dto.TenSanPham;
            sp.Gia = dto.Gia;
            sp.MoTa = dto.MoTa;
            sp.AnhChinh = dto.AnhChinh;
            sp.LoaiId = dto.LoaiId;

            // Xóa toàn bộ ảnh cũ
            _context.HinhAnhSanPhams.RemoveRange(sp.HinhAnhSanPhams);

            // Thêm ảnh mới (nếu có)
            if (dto.HinhAnhs != null && dto.HinhAnhs.Any())
            {
                sp.HinhAnhSanPhams = dto.HinhAnhs.Select(h => new HinhAnhSanPham
                {
                    Url = h.Url,
                    IsChinh = h.IsChinh,
                    SanPhamId = id
                }).ToList();
            }

            _context.SanPhams.Update(sp);
            await _context.SaveChangesAsync();
            return true;
        }

        // 🔴 DELETE
        public async Task<bool> DeleteAsync(int id)
        {
            var sp = await _context.SanPhams
                .Include(x => x.HinhAnhSanPhams)
                .FirstOrDefaultAsync(x => x.Id == id);

            if (sp == null) return false;

            _context.HinhAnhSanPhams.RemoveRange(sp.HinhAnhSanPhams);
            _context.SanPhams.Remove(sp);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
