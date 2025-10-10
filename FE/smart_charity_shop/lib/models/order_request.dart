import 'package:smart_charity_shop/state/cart_provider.dart';

class OrderRequest {
  final String tenNguoiNhan;
  final String soDienThoai;
  final String diaChiNhan;
  final String? ghiChu;
  final String loaiThanhToan;
  final List<OrderItem> chiTiet;

  OrderRequest({
    required this.tenNguoiNhan,
    required this.soDienThoai,
    required this.diaChiNhan,
    this.ghiChu,
    this.loaiThanhToan = "COD", // Mặc định COD
    required this.chiTiet,
  });

  Map<String, dynamic> toJson() => {
    "tenNguoiNhan": tenNguoiNhan,
    "soDienThoai": soDienThoai,
    "diaChiNhan": diaChiNhan,
    "ghiChu": ghiChu,
    "loaiThanhToan": loaiThanhToan,
    "chiTiet": chiTiet.map((e) => e.toJson()).toList(),
  };

  static OrderRequest fromCart({
    required String hoTen,
    required String sdt,
    required String diaChi,
    String? ghiChu,
    String loaiThanhToan = "COD",
    required List<CartItem> cartItems,
  }) {
    return OrderRequest(
      tenNguoiNhan: hoTen,
      soDienThoai: sdt,
      diaChiNhan: diaChi,
      ghiChu: ghiChu,
      loaiThanhToan: loaiThanhToan,
      chiTiet: cartItems
          .map(
            (it) => OrderItem(
              sanPhamId: it.product.id,
              tenSanPham: it.product.tenSanPham,
              giaLucBan: it.product.gia,
              soLuong: it.quantity,
            ),
          )
          .toList(),
    );
  }
}

class OrderItem {
  final int sanPhamId;
  final String tenSanPham;
  final double giaLucBan;
  final int soLuong;

  OrderItem({
    required this.sanPhamId,
    required this.tenSanPham,
    required this.giaLucBan,
    required this.soLuong,
  });

  Map<String, dynamic> toJson() => {
    "sanPhamId": sanPhamId,
    "tenSanPham": tenSanPham,
    "giaLucBan": giaLucBan,
    "soLuong": soLuong,
  };
}
