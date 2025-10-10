using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.DTOs;
using SmartCharityAPI.Repositories;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoaiSanPhamController : ControllerBase
    {
        private readonly ILoaiSanPhamRepository _repo;
        public LoaiSanPhamController(ILoaiSanPhamRepository repo) { _repo = repo; }

        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> GetAll()
            => Ok(await _repo.GetAllAsync());

        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var dto = await _repo.GetByIdAsync(id);
            return dto == null ? NotFound() : Ok(dto);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateLoaiSanPhamDTO dto)
        {
            if (string.IsNullOrWhiteSpace(dto.TenLoai))
                return BadRequest(new { message = "Tên loại không được rỗng." });

            if (await _repo.ExistsByNameAsync(dto.TenLoai))
                return Conflict(new { message = "Tên loại đã tồn tại." });

            var created = await _repo.CreateAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] CreateLoaiSanPhamDTO dto)
        {
            if (await _repo.ExistsByNameAsync(dto.TenLoai, id))
                return Conflict(new { message = "Tên loại đã tồn tại." });

            var ok = await _repo.UpdateAsync(id, dto);
            return ok ? NoContent() : NotFound();
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                var ok = await _repo.DeleteAsync(id);
                return ok ? NoContent() : NotFound();
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
