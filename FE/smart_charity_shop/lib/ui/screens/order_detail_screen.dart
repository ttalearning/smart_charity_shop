import 'package:flutter/material.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    try {
      final data = await OrderService.getOrderDetail(widget.orderId);
      setState(() {
        _order = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng #${widget.orderId}"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text("⚠️ Lỗi: $_error"))
          : _order == null
          ? const Center(child: Text("Không tìm thấy đơn hàng"))
          : RefreshIndicator(
              onRefresh: _loadOrderDetail,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildOrderInfo(),
                  const SizedBox(height: 16),
                  _buildProductList(),
                  const Divider(height: 32),
                  _buildTotalSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderInfo() {
    final o = _order!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mã đơn hàng: #${o['id']}", style: AppTextStyles.bodyBold),
          const SizedBox(height: 4),
          Text(
            "Trạng thái thanh toán: ${o['trangThaiThanhToan'] ?? 'Chưa thanh toán'}",
          ),
          Text("Hình thức thanh toán: ${o['loaiThanhToan'] ?? '---'}"),
          Text("Ngày tạo: ${o['createdAt'] ?? o['ngayTao'] ?? ''}"),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    final List<dynamic> items = _order?['chiTiet'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sản phẩm", style: AppTextStyles.h3),
        const SizedBox(height: 8),
        ...items.map((item) {
          final sp = item;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${ApiConfig.imgUrl}${sp?['anhChinh'] ?? ''}",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFFF2F2F2),
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sp?['tenSanPham'] ?? 'Sản phẩm',
                        style: AppTextStyles.bodyBold,
                      ),
                      const SizedBox(height: 4),
                      Text("SL: ${item['soLuong']}"),
                    ],
                  ),
                ),
                Text(
                  _vnd(item['donGia'] ?? 0),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTotalSection() {
    final tongTien = _order?['tongTien'] ?? _order?['tongTienHang'] ?? 0;
    final tienDonate = _order?['tienDonate'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _row("Tổng tiền hàng", _vnd(tongTien)),
          _row("Tiền quyên góp", _vnd(tienDonate)),
          const Divider(),
          _row("Tổng thanh toán", _vnd(tongTien + tienDonate), bold: true),
        ],
      ),
    );
  }

  Widget _row(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: bold ? AppTextStyles.bodyBold : null),
          Text(right, style: bold ? AppTextStyles.bodyBold : null),
        ],
      ),
    );
  }

  String _vnd(num x) {
    final s = x.toStringAsFixed(0);
    final withSep = s.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return "$withSep₫";
  }
}
