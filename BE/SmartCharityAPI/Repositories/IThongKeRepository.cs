using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface IThongKeRepository
    {
        Task<SummaryDTO> GetSummaryAsync();
        Task<IEnumerable<RevenuePointDTO>> GetRevenueByMonthAsync(int year);
        Task<IEnumerable<TopCampaignDTO>> GetTopCampaignsAsync(int limit);
        Task<IEnumerable<TopDonorDTO>> GetTopDonorsAsync(int limit);
        Task<IEnumerable<RecentOrderDTO>> GetRecentOrdersAsync(int limit);
    }
}
