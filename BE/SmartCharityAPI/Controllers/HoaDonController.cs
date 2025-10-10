using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;

using SmartCharityAPI.Repositories;
using System.Security.Claims;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HoaDonController : ControllerBase
    {
        private readonly IHoaDonRepository _repo;

        public HoaDonController(IHoaDonRepository repo)
        {
            _repo = repo;
        }

        [HttpPost("{userId}")]
        public async Task<IActionResult> Create([FromBody] HoaDonRequestDTO dto, int userId)
        {
            var result = await _repo.CreateAsync(userId, dto);
            return Ok(result);
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetMyOrders(int userId)
        {
            var list = await _repo.GetByUserAsync(userId);
            return Ok(list);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);
            var hd = await _repo.GetByIdAsync(id, userId);
            return hd == null ? NotFound() : Ok(hd);
        }
    }
}
