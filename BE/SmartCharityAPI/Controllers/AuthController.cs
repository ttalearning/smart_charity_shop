using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Repositories;
using System.Security.Claims;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthRepository _authRepo;

        public AuthController(IAuthRepository authRepo)
        {
            _authRepo = authRepo;
        }

        [HttpPost("register")]
        [AllowAnonymous]
        public async Task<IActionResult> Register([FromBody] RegisterDTO dto)
        {
            try
            {
                var result = await _authRepo.RegisterAsync(dto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] LoginDTO dto)
        {
            var result = await _authRepo.LoginAsync(dto);
            if (result == null)
                return Unauthorized(new { message = "Sai email hoặc mật khẩu" });

            return Ok(result);
        }

        [HttpPost("login-google")]
        [AllowAnonymous]
        public async Task<IActionResult> LoginGoogle([FromBody] GoogleLoginDTO dto)
        {
            var result = await _authRepo.LoginGoogleAsync(dto);
            return Ok(result);
        }

        [HttpGet("profile")]
        [Authorize]
        public IActionResult Profile()
        {
            var claims = User.Claims.ToDictionary(c => c.Type, c => c.Value);
            return Ok(new
            {
                Id = claims["UserId"],
                Email = claims[ClaimTypes.NameIdentifier] ?? claims["sub"],
                Role = claims["Role"],
                Message = "Authorized"
            });
        }

        
    }
}
