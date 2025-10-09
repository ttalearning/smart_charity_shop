using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Repositories;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class SanPhamController : ControllerBase
    {
        private readonly ISanPhamRepository _repo;

        public SanPhamController(ISanPhamRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var list = await _repo.GetAllAsync();
            return Ok(list);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var sp = await _repo.GetByIdAsync(id);
            if (sp == null) return NotFound();
            return Ok(sp);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] SanPhamDTO dto)
        {
            var sp = await _repo.CreateAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = sp.Id }, sp);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] SanPhamDTO dto)
        {
            var ok = await _repo.UpdateAsync(id, dto);
            return ok ? NoContent() : NotFound();
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var ok = await _repo.DeleteAsync(id);
            return ok ? NoContent() : NotFound();
        }
    }
}
