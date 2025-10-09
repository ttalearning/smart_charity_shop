using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Repositories;
using System.Security.Claims;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ChienDichController : ControllerBase
    {
        private readonly IChienDichRepository _repo;

        public ChienDichController(IChienDichRepository repo)
        {
            _repo = repo;
        }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var list = await _repo.GetAllAsync();
            return Ok(list);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var cd = await _repo.GetByIdAsync(id);
            return cd == null ? NotFound() : Ok(cd);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateChienDichDTO dto)
        {
            var adminId = int.Parse(User.FindFirst("UserId")!.Value);
            var created = await _repo.CreateAsync(dto, adminId);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] CreateChienDichDTO dto)
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

        [Authorize(Roles = "Admin")]
        [HttpPost("{id}/images")]
        public async Task<IActionResult> AddImages(int id, [FromBody] List<string> urls)
        {
            var ok = await _repo.AddImagesAsync(id, urls);
            return ok ? Ok(new { message = "Đã thêm hình ảnh" }) : NotFound();
        }
    }
}
