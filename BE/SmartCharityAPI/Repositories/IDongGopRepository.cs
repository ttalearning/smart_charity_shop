using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface IDongGopRepository
    {
        Task<IEnumerable<DongGopDTO>> GetAllAsync();
        Task<IEnumerable<DongGopDTO>> GetByCampaignAsync(int campaignId);

        Task<IEnumerable<DongGopDTO>> GetByUserAsync(int userId);
        Task<bool> CreateAsync(int userId, CreateDongGopDTO dto);
        Task<IEnumerable<TopDongGopDTO>> GetTopAsync(int limit = 10);
    }
}
