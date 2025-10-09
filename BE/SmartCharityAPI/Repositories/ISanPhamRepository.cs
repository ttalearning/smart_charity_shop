using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface ISanPhamRepository
    {
        Task<IEnumerable<SanPhamDTO>> GetAllAsync();
        Task<SanPhamDTO?> GetByIdAsync(int id);
        Task<SanPhamDTO> CreateAsync(SanPhamDTO dto);
        Task<bool> UpdateAsync(int id, SanPhamDTO dto);
        Task<bool> DeleteAsync(int id);
    }
}
