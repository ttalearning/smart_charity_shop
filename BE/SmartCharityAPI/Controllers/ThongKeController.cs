using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.Repositories;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class ThongKeController : ControllerBase
    {
        private readonly IThongKeRepository _repo;

        public ThongKeController(IThongKeRepository repo)
        {
            _repo = repo;
        }

        [HttpGet("summary")]
        public async Task<IActionResult> Summary()
        {
            var res = await _repo.GetSummaryAsync();
            return Ok(res);
        }

        [HttpGet("revenue-by-month")]
        public async Task<IActionResult> RevenueByMonth([FromQuery] int year)
        {
            if (year <= 0) year = DateTime.UtcNow.Year;
            var res = await _repo.GetRevenueByMonthAsync(year);
            return Ok(res);
        }

        [HttpGet("top-campaigns")]
        public async Task<IActionResult> TopCampaigns([FromQuery] int limit = 5)
        {
            var res = await _repo.GetTopCampaignsAsync(limit);
            return Ok(res);
        }

        [HttpGet("top-donors")]
        public async Task<IActionResult> TopDonors([FromQuery] int limit = 5)
        {
            var res = await _repo.GetTopDonorsAsync(limit);
            return Ok(res);
        }

        [HttpGet("recent-orders")]
        public async Task<IActionResult> RecentOrders([FromQuery] int limit = 10)
        {
            var res = await _repo.GetRecentOrdersAsync(limit);
            return Ok(res);
        }
    }
}
