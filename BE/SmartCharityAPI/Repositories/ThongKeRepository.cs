using SmartCharityAPI.DTOs;
using SmartCharityAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace SmartCharityAPI.Repositories
{
    public class ThongKeRepository : IThongKeRepository
    {
        private readonly SmartCharityContext _context;

        public ThongKeRepository(SmartCharityContext context)
        {
            _context = context;
        }

        public async Task<SummaryDTO> GetSummaryAsync()
        {
            var tongDoanhThu = await _context.HoaDons.SumAsync(h => (decimal?)h.TongThanhToan) ?? 0m;
            var tongDonate = await _context.DongGops.SumAsync(d => (decimal?)d.SoTien) ?? 0m;
            var tongHoaDon = await _context.HoaDons.CountAsync();
            var tongChienDich = await _context.ChienDiches.CountAsync();

            return new SummaryDTO
            {
                TongDoanhThu = tongDoanhThu,
                TongDonate = tongDonate,
                TongHoaDon = tongHoaDon,
                TongChienDich = tongChienDich,
                TiLeDonate = tongDoanhThu == 0 ? 0 : Math.Round(tongDonate / tongDoanhThu, 4)
            };
        }

        

        public async Task<IEnumerable<TopCampaignDTO>> GetTopCampaignsAsync(int limit)
        {
            // Tính theo bảng DongGop để chính xác cả donate từ hóa đơn & thủ công
            var top = await _context.DongGops
                .Include(d => d.ChienDich)
                .GroupBy(d => d.ChienDichId)
                .Select(g => new TopCampaignDTO
                {
                    ChienDichId = g.Key,
                    TenChienDich = g.First().ChienDich.TenChienDich,
                    HinhAnhChinh = g.First().ChienDich.HinhAnhChinh,
                    TongDonate = g.Sum(x => x.SoTien),
                    MucTieu = g.First().ChienDich.MucTieu,
                    SoTienHienTai = g.First().ChienDich.SoTienHienTai
                })
                .OrderByDescending(x => x.TongDonate)
                .Take(limit)
                .ToListAsync();

            return top;
        }

        public async Task<IEnumerable<TopDonorDTO>> GetTopDonorsAsync(int limit)
        {
            var top = await _context.DongGops
                .Include(d => d.NguoiDung)
                .GroupBy(d => new { d.NguoiDungId, d.NguoiDung.HoTen, d.NguoiDung.AvatarUrl })
                .Select(g => new TopDonorDTO
                {
                    NguoiDungId = g.Key.NguoiDungId,
                    TenNguoiDung = g.Key.HoTen,
                    AvatarUrl = g.Key.AvatarUrl,
                    TongDonate = g.Sum(x => x.SoTien)
                })
                .OrderByDescending(x => x.TongDonate)
                .Take(limit)
                .ToListAsync();

            return top;
        }

        
    }
}
