using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Interfaces;
using System.Security.Claims;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository _repo;

        public UserController(IUserRepository repo)
        {
            _repo = repo;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var users = await _repo.GetAllAsync();
            return Ok(users);
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var user = await _repo.GetByIdAsync(id);
            return user == null ? NotFound() : Ok(user);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/role")]
        public async Task<IActionResult> UpdateRole(int id, [FromBody] UpdateRoleDTO dto)
        {
            var ok = await _repo.UpdateRoleAsync(id, dto.VaiTro);
            return ok ? Ok(new { message = "Cập nhật vai trò thành công" }) : NotFound();
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/status")]
        public async Task<IActionResult> UpdateStatus(int id, [FromBody] UpdateStatusDTO dto)
        {
            var ok = await _repo.UpdateStatusAsync(id, dto.TrangThai);
            return ok ? Ok(new { message = "Cập nhật trạng thái thành công" }) : NotFound();
        }

        [Authorize]
        [HttpGet("me")]
        public async Task<IActionResult> GetProfile()
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);
            var user = await _repo.GetCurrentUserAsync(userId);
            return user == null ? NotFound() : Ok(user);
        }
    }
}
