using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Interfaces
{
    public interface IUserRepository
    {
        Task<IEnumerable<UserDTO>> GetAllAsync();
        Task<UserDTO?> GetByIdAsync(int id);
        Task<bool> UpdateRoleAsync(int id, string role);
        Task<bool> UpdateStatusAsync(int id, bool status);
        Task<UserDTO?> GetCurrentUserAsync(int userId);
    }
}
