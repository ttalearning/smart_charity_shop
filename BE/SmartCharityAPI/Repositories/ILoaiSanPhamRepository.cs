using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface ILoaiSanPhamRepository
    {
        Task<IEnumerable<LoaiSanPhamDTO>> GetAllAsync();
        Task<LoaiSanPhamDTO?> GetByIdAsync(int id);
        Task<LoaiSanPhamDTO> CreateAsync(CreateLoaiSanPhamDTO dto);
        Task<bool> UpdateAsync(int id, CreateLoaiSanPhamDTO dto);
        Task<bool> DeleteAsync(int id);
        Task<bool> ExistsByNameAsync(string tenLoai, int? excludeId = null);
    }
}
