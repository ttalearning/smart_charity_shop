using System;
using System.Collections.Generic;

namespace SmartCharityAPI.DTOs
{
    // ================================
    // Request DTO
    // ================================
    public class HoaDonRequestDTO
    {
        public int NguoiDungId { get; set; }                     // Người dùng mua                  // Dành cho donate
        public string LoaiThanhToan { get; set; } = "COD";       // COD / Momo / VNPay
        public string? TenNguoiNhan { get; set; }

        public string? TrangThaiThanhToan { get; set; }

        public int? ChienDichId { get; set; }

        public string? SoDienThoai { get; set; }
        public string? DiaChiNhan { get; set; }
        public string? GhiChu { get; set; }

        public List<ChiTietHoaDonDTO> ChiTiet { get; set; } = new();
    }

    // ================================
    // Chi tiết đơn hàng
    // ================================
    public class ChiTietHoaDonDTO
    {
        public int SanPhamId { get; set; }
        public string? TenSanPham { get; set; }
        public int SoLuong { get; set; }
        public decimal GiaLucBan { get; set; }
        public decimal ThanhTien => Math.Round(GiaLucBan * SoLuong, 2);
    }

    // ================================
    // Response DTO
    // ================================
    public class HoaDonResponseDTO
    {
        public int Id { get; set; }
        public decimal TongTienHang { get; set; }
        public decimal PhiShip { get; set; }
        public decimal GiamGia { get; set; }
        public decimal Thue { get; set; }
        public decimal TongThanhToan { get; set; }

        public string LoaiThanhToan { get; set; } = "";
        public string TrangThaiThanhToan { get; set; } = "";
        public string TrangThaiDonHang { get; set; } = "";

        public string? TenNguoiNhan { get; set; }
        public string? SoDienThoai { get; set; }
        public string? DiaChiNhan { get; set; }
        public string? GhiChu { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public List<ChiTietHoaDonDTO> ChiTiet { get; set; } = new();
        public decimal TienDonate { get; set; }                   // tổng giá trị donate (nếu có)
    }
}
