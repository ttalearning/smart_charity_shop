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
            if (cd == null) return NotFound(new { message = "Không tìm thấy chiến dịch" });
            return Ok(cd);
        }
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateChienDichDTO dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var adminId = int.Parse(User.FindFirstValue("UserId")!);

            var created = await _repo.CreateAsync(dto, adminId);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

 
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] CreateChienDichDTO dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var ok = await _repo.UpdateAsync(id, dto);
            if (!ok) return NotFound(new { message = "Không tìm thấy chiến dịch cần cập nhật" });

            return Ok(new { message = "Cập nhật thành công" });
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var ok = await _repo.DeleteAsync(id);
            if (!ok) return NotFound(new { message = "Không tìm thấy chiến dịch để xóa" });

            return Ok(new { message = "Xóa thành công" });
        }
    }
}
