using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface IHoaDonRepository
    {
        Task<HoaDonResponseDTO> CreateAsync(int userId, HoaDonRequestDTO dto);
        Task<IEnumerable<HoaDonResponseDTO>> GetByUserAsync(int userId);
        Task<HoaDonResponseDTO?> GetByIdAsync(int id, int userId);
    }
}
