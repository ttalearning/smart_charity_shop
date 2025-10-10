import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';
import '/../state/cart_provider.dart';
import '/../models/order_request.dart';
import '/../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoTenCtl = TextEditingController();
  final _sdtCtl = TextEditingController();
  final _diaChiCtl = TextEditingController();
  final _ghiChuCtl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _hoTenCtl.dispose();
    _sdtCtl.dispose();
    _diaChiCtl.dispose();
    _ghiChuCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final sub = cart.subTotal;
    final donation = cart.donation10;
    final total = sub; // nếu có ship/giảm giá, cộng/trừ ở đây

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle('Thông tin người nhận'),
            const SizedBox(height: 8),
            _Input(
              controller: _hoTenCtl,
              label: 'Họ và tên',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Vui lòng nhập họ tên'
                  : null,
            ),
            _Input(
              controller: _sdtCtl,
              label: 'Số điện thoại',
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.trim().length < 8) ? 'SĐT chưa hợp lệ' : null,
            ),
            _Input(
              controller: _diaChiCtl,
              label: 'Địa chỉ nhận hàng',
              maxLines: 2,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Vui lòng nhập địa chỉ'
                  : null,
            ),
            _Input(
              controller: _ghiChuCtl,
              label: 'Ghi chú (tuỳ chọn)',
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            _SectionTitle('Giỏ hàng'),
            const SizedBox(height: 8),
            ...cart.items.map((it) => _CartLine(item: it)).toList(),
            const SizedBox(height: 8),

            _SummaryRow('Tạm tính', _vnd(sub)),
            _SummaryRow.rich(
              left: Row(
                children: const [
                  Text('Đóng góp (10%)'),
                  SizedBox(width: 6),
                  Icon(
                    Icons.volunteer_activism_rounded,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ],
              ),
              right: Text(
                _vnd(donation),
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
            const Divider(height: 24),
            _SummaryRow.bold('Tổng thanh toán', _vnd(total)),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : () => _submit(cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Xác nhận đặt hàng'),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                '10% giá trị hoá đơn sẽ được quyên góp vào quỹ thiện nguyện.',
                style: AppTextStyles.caption.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(CartProvider cart) async {
    if (!_formKey.currentState!.validate()) return;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giỏ hàng đang trống')));
      return;
    }

    setState(() => _submitting = true);

    try {
      final req = OrderRequest.fromCart(
        hoTen: _hoTenCtl.text.trim(),
        sdt: _sdtCtl.text.trim(),
        diaChi: _diaChiCtl.text.trim(),
        ghiChu: _ghiChuCtl.text.trim().isEmpty ? null : _ghiChuCtl.text.trim(),
        cartItems: cart.items,
      );

      final result = await OrderService.createOrder(req);

      // Nếu OK → xoá giỏ + báo thành công
      cart.clear();
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Đặt hàng thành công'),
          content: Text(
            'Mã đơn: ${result['orderId'] ?? '(chưa rõ)'}\n'
            'Tổng: ${_vnd((result['total'] ?? 0).toDouble())}\n'
            'Đóng góp: ${_vnd((result['donation'] ?? 0).toDouble())}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context); // quay lại
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi đặt hàng: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.h3);
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _Input({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  final CartItem item;
  const _CartLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.product.anhChinh ?? "",
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              color: const Color(0xFFF2F2F2),
              child: const Icon(Icons.image_not_supported_rounded),
            ),
          ),
        ),
        title: Text(
          item.product.tenSanPham,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${item.quantity} × ${_vnd(item.product.gia)}'),
        trailing: Text(_vnd(item.lineTotal), style: AppTextStyles.bodyBold),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _SummaryRow._(this.left, this.right);

  factory _SummaryRow(String l, String r) => _SummaryRow._(Text(l), Text(r));

  factory _SummaryRow.bold(String l, String r) => _SummaryRow._(
    Text(l, style: AppTextStyles.bodyBold),
    Text(r, style: AppTextStyles.bodyBold),
  );

  factory _SummaryRow.rich({required Widget left, required Widget right}) =>
      _SummaryRow._(left, right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [left, right],
      ),
    );
  }
}

String _vnd(double x) {
  final s = x.toStringAsFixed(0);
  final withSep = s.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return "$withSep₫";
}
