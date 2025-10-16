using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Repositories
{
    public class ChienDichRepository : IChienDichRepository
    {
        private readonly SmartCharityContext _context;

        public ChienDichRepository(SmartCharityContext context)
        {
            _context = context;
        }

        // 🟢 Lấy tất cả chiến dịch
        public async Task<IEnumerable<ChienDichDTO>> GetAllAsync()
        {
            return await _context.ChienDiches
                .Include(cd => cd.HinhAnhChienDiches)
                .Select(cd => new ChienDichDTO
                {
                    Id = cd.Id,
                    TenChienDich = cd.TenChienDich,
                    MoTa = cd.MoTa,
                    HinhAnhChinh = cd.HinhAnhChinh,
                    MucTieu = cd.MucTieu,
                    SoTienHienTai = cd.SoTienHienTai,
                    TrangThai = cd.TrangThai,
                    DiaDiem = cd.DiaDiem,
                    NgayBatDau = cd.NgayBatDau,
                    NgayKetThuc = cd.NgayKetThuc,
                    HinhAnhs = cd.HinhAnhChienDiches
                        .Select(h => new HinhAnhChienDichDTO
                        {
                            Id = h.Id,
                            Url = h.Url,
                            ChienDichId = h.ChienDichId,
                            IsChinh = h.IsChinh ?? false
                        }).ToList()
                })
                .ToListAsync();
        }

        // 🟡 Lấy 1 chiến dịch theo ID
        public async Task<ChienDichDTO?> GetByIdAsync(int id)
        {
            return await _context.ChienDiches
                .Include(cd => cd.HinhAnhChienDiches)
                .Where(cd => cd.Id == id)
                .Select(cd => new ChienDichDTO
                {
                    Id = cd.Id,
                    TenChienDich = cd.TenChienDich,
                    MoTa = cd.MoTa,
                    HinhAnhChinh = cd.HinhAnhChinh,
                    MucTieu = cd.MucTieu,
                    SoTienHienTai = cd.SoTienHienTai,
                    TrangThai = cd.TrangThai,
                    DiaDiem = cd.DiaDiem,
                    NgayBatDau = cd.NgayBatDau,
                    NgayKetThuc = cd.NgayKetThuc,
                    HinhAnhs = cd.HinhAnhChienDiches
                        .Select(h => new HinhAnhChienDichDTO
                        {
                            Id = h.Id,
                            Url = h.Url,
                            ChienDichId = h.ChienDichId,
                            IsChinh = h.IsChinh ?? false
                        })
                        .ToList()
                })
                .FirstOrDefaultAsync();
        }

        // 🟢 CREATE (thêm chiến dịch + danh sách ảnh phụ)
        public async Task<ChienDichDTO> CreateAsync(CreateChienDichDTO dto, int adminId)
        {
            var entity = new ChienDich
            {
                TenChienDich = dto.TenChienDich,
                MoTa = dto.MoTa,
                HinhAnhChinh = dto.HinhAnhChinh,
                MucTieu = dto.MucTieu,
                SoTienHienTai = 0,
                TrangThai = "Đang diễn ra",
                DiaDiem = dto.DiaDiem,
                NgayBatDau = dto.NgayBatDau ?? DateTime.UtcNow,
                NgayKetThuc = dto.NgayKetThuc,
                NguoiTaoId = adminId,
                HinhAnhChienDiches = dto.HinhAnhs?.Select(h => new HinhAnhChienDich
                {
                    Url = h.Url,
                    IsChinh = h.IsChinh
                }).ToList() ?? new List<HinhAnhChienDich>()
            };

            _context.ChienDiches.Add(entity);
            await _context.SaveChangesAsync();

            // Gán lại Id cho DTO sau khi lưu
            return await GetByIdAsync(entity.Id) ?? new ChienDichDTO();
        }

        // 🟡 UPDATE (cập nhật chiến dịch + thay thế toàn bộ ảnh)
        public async Task<bool> UpdateAsync(int id, CreateChienDichDTO dto)
        {
            var cd = await _context.ChienDiches
                .Include(x => x.HinhAnhChienDiches)
                .FirstOrDefaultAsync(x => x.Id == id);

            if (cd == null) return false;

            cd.TenChienDich = dto.TenChienDich;
            cd.MoTa = dto.MoTa;
            cd.HinhAnhChinh = dto.HinhAnhChinh;
            cd.MucTieu = dto.MucTieu;
            cd.DiaDiem = dto.DiaDiem;
            cd.NgayBatDau = dto.NgayBatDau;
            cd.NgayKetThuc = dto.NgayKetThuc;

            // Xóa ảnh cũ
            _context.HinhAnhChienDiches.RemoveRange(cd.HinhAnhChienDiches);

            // Thêm lại danh sách ảnh mới
            if (dto.HinhAnhs != null && dto.HinhAnhs.Any())
            {
                cd.HinhAnhChienDiches = dto.HinhAnhs.Select(h => new HinhAnhChienDich
                {
                    Url = h.Url,
                    IsChinh = h.IsChinh,
                    ChienDichId = id
                }).ToList();
            }

            await _context.SaveChangesAsync();
            return true;
        }

        // 🔴 DELETE (xóa chiến dịch + ảnh liên quan)
        public async Task<bool> DeleteAsync(int id)
        {
            var cd = await _context.ChienDiches
                .Include(x => x.HinhAnhChienDiches)
                .FirstOrDefaultAsync(x => x.Id == id);

            if (cd == null) return false;

            _context.HinhAnhChienDiches.RemoveRange(cd.HinhAnhChienDiches);
            _context.ChienDiches.Remove(cd);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
