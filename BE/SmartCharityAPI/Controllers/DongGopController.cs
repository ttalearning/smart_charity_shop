using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Repositories;
using System.Security.Claims;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DongGopController : ControllerBase
    {
        private readonly IDongGopRepository _repo;

        public DongGopController(IDongGopRepository repo)
        {
            _repo = repo;
        }

        [AllowAnonymous]
        [HttpGet("top")]
        public async Task<IActionResult> GetTop()
        {
            var top = await _repo.GetTopAsync();
            return Ok(top);
        }
        [HttpGet("by-campaign/{campaignId}")]
        public async Task<IActionResult> GetByCampaign(int campaignId)
        {
            var list = await _repo.GetByCampaignAsync(campaignId);
            return Ok(list);
        }

        [Authorize]
        [HttpGet("{userId}")]
        public async Task<IActionResult> GetMyDonations(int userId)
        {
            var list = await _repo.GetByUserAsync(userId);
            return Ok(list);
        }

        [Authorize]
        [HttpPost("create")]
        public async Task<IActionResult> Create([FromBody] CreateDongGopDTO dto)
        {
            var userId = int.Parse(User.FindFirst("UserId")!.Value);
            var ok = await _repo.CreateAsync(userId, dto);
            return ok ? Ok(new { message = "Đóng góp thành công" }) : NotFound(new { message = "Chiến dịch không tồn tại" });
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var list = await _repo.GetAllAsync();
            return Ok(list);
        }
    }
}
