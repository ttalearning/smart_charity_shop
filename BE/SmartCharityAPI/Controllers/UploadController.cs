using Microsoft.AspNetCore.Mvc;
using SmartCharityAPI.Models;

namespace SmartCharityAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UploadController : ControllerBase
    {
        private readonly IWebHostEnvironment _env;

        public UploadController(IWebHostEnvironment env)
        {
            _env = env;
        }

        [HttpPost("{type}")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> Upload([FromRoute] string type, [FromForm] UploadFileDTO dto)
        {
            var file = dto.File;
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded.");

            var safeType = type.ToLower() == "campaign" ? "campaign" : "product";
            var folderPath = Path.Combine(_env.WebRootPath ?? "wwwroot", "uploads", safeType);

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine(folderPath, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            // ✅ Trả về đường dẫn tương đối
            return Ok(new { url = $"uploads/{safeType}/{fileName}" });
        }
    }
}
