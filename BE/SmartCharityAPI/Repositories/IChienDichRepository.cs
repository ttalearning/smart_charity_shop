using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface IChienDichRepository
    {
        Task<IEnumerable<ChienDichDTO>> GetAllAsync();
        Task<ChienDichDTO?> GetByIdAsync(int id);
        Task<ChienDichDTO> CreateAsync(CreateChienDichDTO dto, int adminId);
        Task<bool> UpdateAsync(int id, CreateChienDichDTO dto);
        Task<bool> DeleteAsync(int id);
        Task<bool> AddImagesAsync(int chienDichId, List<string> imageUrls);
    }
}
