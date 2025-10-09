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
            var tongDoanhThu = await _context.HoaDons.SumAsync(h => (decimal?)h.TongTien) ?? 0m;
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

        public async Task<IEnumerable<RevenuePointDTO>> GetRevenueByMonthAsync(int year)
        {
            int yearNow = DateTime.Now.Year;
            var data = await _context.HoaDons
                .Where(h => (h.NgayTao ?? DateTime.Now).Year == year)
                .GroupBy(h => (h.NgayTao ?? DateTime.Now).Month)
                .Select(g => new RevenuePointDTO
                {
                    Thang = g.Key,
                    DoanhThu = g.Sum(x => x.TongTien),
                    Donate = g.Sum(x => x.TienDonate),
                    SoHoaDon = g.Count()
                })
                .ToListAsync();

            // Bổ sung tháng không có dữ liệu (0) để chart đẹp
            var map = data.ToDictionary(x => x.Thang);
            var result = new List<RevenuePointDTO>();
            for (int m = 1; m <= 12; m++)
            {
                if (map.TryGetValue(m, out var v)) result.Add(v);
                else result.Add(new RevenuePointDTO { Thang = m, DoanhThu = 0, Donate = 0, SoHoaDon = 0 });
            }
            return result.OrderBy(x => x.Thang);
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

        public async Task<IEnumerable<RecentOrderDTO>> GetRecentOrdersAsync(int limit)
        {
            var q = await _context.HoaDons
                .Include(h => h.NguoiDung)
                .Include(h => h.ChienDich)
                .OrderByDescending(h => h.NgayTao)
                .Take(limit)
                .Select(h => new RecentOrderDTO
                {
                    Id = h.Id,
                    NgayTao = h.NgayTao ?? DateTime.Now,
                    TongTien = h.TongTien,
                    TienDonate = h.TienDonate,
                    LoaiThanhToan = h.LoaiThanhToan,
                    TrangThaiThanhToan = h.TrangThaiThanhToan,
                    TenChienDich = h.ChienDich.TenChienDich,
                    TenKhach = h.NguoiDung.HoTen
                })
                .ToListAsync();

            return q;
        }
    }
}
