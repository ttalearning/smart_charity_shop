import 'package:smart_charity_shop/state/cart_provider.dart';

class OrderRequest {
  final String tenNguoiNhan;
  final String soDienThoai;
  final String diaChiNhan;
  final String? ghiChu;
  final String loaiThanhToan;
  final String? loiNhan;
  final String trangThaiThanhToan;
  final int? chienDichId;
  final List<OrderItem> chiTiet;

  OrderRequest({
    required this.tenNguoiNhan,
    required this.soDienThoai,
    required this.diaChiNhan,
    required this.loiNhan,
    required this.trangThaiThanhToan,
    this.ghiChu,
    this.loaiThanhToan = "COD",
    this.chienDichId, // ✅ thêm
    required this.chiTiet,
  });

  Map<String, dynamic> toJson() => {
    "tenNguoiNhan": tenNguoiNhan,
    "soDienThoai": soDienThoai,
    "diaChiNhan": diaChiNhan,
    "ghiChu": ghiChu,
    "loiNhan": loiNhan,
    "loaiThanhToan": loaiThanhToan,
    "trangThaiThanhToan": trangThaiThanhToan,
    "chienDichId": chienDichId,
    "chiTiet": chiTiet.map((e) => e.toJson()).toList(),
  };

  /// ✅ Dễ dàng khởi tạo từ giỏ hàng
  static OrderRequest fromCart({
    required String hoTen,
    required String sdt,
    required String diaChi,
    required String loinhan,
    required List<CartItem> cartItems,
    String? ghiChu,
    String loaiThanhToan = "COD",
    String trangThaiThanhToan = "PENDING",
    int? chienDichId,
  }) {
    return OrderRequest(
      tenNguoiNhan: hoTen,
      soDienThoai: sdt,
      diaChiNhan: diaChi,
      loiNhan: loinhan,
      ghiChu: ghiChu,
      loaiThanhToan: loaiThanhToan,
      trangThaiThanhToan: trangThaiThanhToan,
      chienDichId: chienDichId,
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
