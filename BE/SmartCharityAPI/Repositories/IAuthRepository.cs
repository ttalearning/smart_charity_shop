using SmartCharityAPI.DTOs;

namespace SmartCharityAPI.Repositories
{
    public interface IAuthRepository
    {
        Task<AuthResponseDTO> RegisterAsync(RegisterDTO dto);
        Task<AuthResponseDTO?> LoginAsync(LoginDTO dto);
        Task<AuthResponseDTO> LoginGoogleAsync(GoogleLoginDTO dto);
    }
}
