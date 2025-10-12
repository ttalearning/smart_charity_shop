import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_charity_shop/services/order_service.dart';
import 'package:smart_charity_shop/ui/screens/home_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final int id;
  const OrderSuccessScreen({super.key, required this.id});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;

  String _vnd(num value) =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
  }

  Future<void> _fetchOrderDetail() async {
    try {
      final data = await OrderService.getOrderDetail(widget.id);
      setState(() {
        _order = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint("🔴 Lỗi khi tải chi tiết đơn hàng: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_order == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy thông tin đơn hàng")),
      );
    }

    final order = _order!;
    final chiTiet = (order['chiTiet'] as List?) ?? [];
    final createdAt = order['createdAt'] ?? '';
    final trangThai = order['trangThaiThanhToan'] ?? 'Đang xử lý';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng thành công'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 12),
                  Text(
                    'Cảm ơn bạn đã đặt hàng!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mã đơn: #${order['id']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Ngày đặt: $createdAt',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Thông tin thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            _infoRow('Loại thanh toán', order['loaiThanhToan']),
            _infoRow('Trạng thái', trangThai),
            _infoRow('Tổng tiền hàng', _vnd(order['tongTienHang'] ?? 0)),
            _infoRow('Đóng góp', _vnd(order['tienDonate'] ?? 0)),

            const SizedBox(height: 24),

            const Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: chiTiet.isEmpty
                  ? const Center(child: Text("Không có sản phẩm nào"))
                  : ListView.builder(
                      itemCount: chiTiet.length,
                      itemBuilder: (_, i) {
                        final p = chiTiet[i];
                        final gia = p['giaLucBan'] ?? p['gia'] ?? 0;
                        final sl = p['soLuong'] ?? 1;
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag_outlined),
                          title: Text(p['tenSanPham'] ?? 'Sản phẩm'),
                          subtitle: Text('x$sl'),
                          trailing: Text(
                            _vnd(gia * sl),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Về Trang Chủ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (_) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Flexible(
            child: Text(
              value?.toString() ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
