using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using Microsoft.EntityFrameworkCore;


namespace SmartCharityAPI.Repositories
{
    namespace SmartCharityAPI.Repositories
    {
        public class ChienDichRepository : IChienDichRepository
        {
            private readonly SmartCharityContext _context;

            public ChienDichRepository(SmartCharityContext context)
            {
                _context = context;
            }

            public async Task<IEnumerable<ChienDichDTO>> GetAllAsync()
            {
                return await _context.ChienDiches
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
                        HinhAnhPhu = _context.HinhAnhChienDiches
                            .Where(x => x.ChienDichId == cd.Id)
                            .Select(x => x.Url).ToList()
                    }).ToListAsync();
            }

            public async Task<ChienDichDTO?> GetByIdAsync(int id)
            {
                var cd = await _context.ChienDiches.FirstOrDefaultAsync(x => x.Id == id);
                if (cd == null) return null;

                var images = await _context.HinhAnhChienDiches
                    .Where(x => x.ChienDichId == id)
                    .Select(x => x.Url)
                    .ToListAsync();

                return new ChienDichDTO
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
                    HinhAnhPhu = images
                };
            }

            public async Task<ChienDichDTO> CreateAsync(CreateChienDichDTO dto, int adminId)
            {
                var cd = new ChienDich
                {
                    TenChienDich = dto.TenChienDich,
                    MoTa = dto.MoTa,
                    HinhAnhChinh = dto.HinhAnhChinh,
                    MucTieu = dto.MucTieu,
                    SoTienHienTai = 0,
                    TrangThai = "Đang diễn ra",
                    DiaDiem = dto.DiaDiem,
                    NguoiTaoId = adminId,
                    NgayBatDau = dto.NgayBatDau ?? DateTime.UtcNow,
                    NgayKetThuc = dto.NgayKetThuc
                };

                _context.ChienDiches.Add(cd);
                await _context.SaveChangesAsync();

                return await GetByIdAsync(cd.Id) ?? new ChienDichDTO();
            }

            public async Task<bool> UpdateAsync(int id, CreateChienDichDTO dto)
            {
                var cd = await _context.ChienDiches.FindAsync(id);
                if (cd == null) return false;

                cd.TenChienDich = dto.TenChienDich;
                cd.MoTa = dto.MoTa;
                cd.HinhAnhChinh = dto.HinhAnhChinh;
                cd.MucTieu = dto.MucTieu;
                cd.DiaDiem = dto.DiaDiem;
                cd.NgayBatDau = dto.NgayBatDau;
                cd.NgayKetThuc = dto.NgayKetThuc;

                await _context.SaveChangesAsync();
                return true;
            }

            public async Task<bool> DeleteAsync(int id)
            {
                var cd = await _context.ChienDiches.FindAsync(id);
                if (cd == null) return false;

                _context.ChienDiches.Remove(cd);
                await _context.SaveChangesAsync();
                return true;
            }

            public async Task<bool> AddImagesAsync(int chienDichId, List<string> imageUrls)
            {
                if (!await _context.ChienDiches.AnyAsync(c => c.Id == chienDichId))
                    return false;

                foreach (var url in imageUrls)
                {
                    _context.HinhAnhChienDiches.Add(new HinhAnhChienDich
                    {
                        ChienDichId = chienDichId,
                        Url = url,
                        IsChinh = false
                    });
                }
                await _context.SaveChangesAsync();
                return true;
            }
        }
    }
    
}
