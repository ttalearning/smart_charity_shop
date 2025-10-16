import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import 'package:smart_charity_shop/services/momo_service.dart';
import 'package:smart_charity_shop/services/order_service.dart';
import 'package:smart_charity_shop/services/campaign_service.dart';
import 'package:smart_charity_shop/ui/screens/order_success_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../state/cart_provider.dart';
import '../../models/order_request.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hoTenCtl = TextEditingController();
  final _sdtCtl = TextEditingController();
  final _loiNhanCtl = TextEditingController();
  final _diaChiCtl = TextEditingController();
  final _ghiChuCtl = TextEditingController();

  bool _submitting = false;
  String _paymentMethod = "cash"; // cash | momo
  int? _selectedCampaignId;
  List<dynamic> _campaigns = [];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    final data = await CampaignService.fetchAll();
    setState(() => _campaigns = data);
  }

  @override
  void dispose() {
    _hoTenCtl.dispose();
    _sdtCtl.dispose();
    _diaChiCtl.dispose();
    _loiNhanCtl.dispose();
    _ghiChuCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final sub = cart.subTotal;
    final donation = cart.donation10;
    final total = sub;

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
            _Input(
              controller: _hoTenCtl,
              label: 'Họ và tên',
              validator: (v) => v!.isEmpty ? 'Nhập họ tên' : null,
            ),
            _Input(
              controller: _sdtCtl,
              label: 'Số điện thoại',
              keyboardType: TextInputType.phone,
              validator: (v) => v!.length < 8 ? 'SĐT chưa hợp lệ' : null,
            ),
            _Input(
              controller: _diaChiCtl,
              label: 'Địa chỉ',
              maxLines: 2,
              validator: (v) => v!.isEmpty ? 'Nhập địa chỉ' : null,
            ),

            _Input(
              controller: _ghiChuCtl,
              label: 'Ghi chú (tuỳ chọn)',
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            _SectionTitle('Phương thức thanh toán'),
            RadioListTile<String>(
              title: const Text("Tiền mặt khi nhận hàng"),
              value: "cash",
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            RadioListTile<String>(
              title: const Text("Thanh toán MoMo"),
              value: "momo",
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),

            const SizedBox(height: 12),
            _SectionTitle('Chiến dịch thiện nguyện'),
            DropdownButtonFormField<int>(
              value: _selectedCampaignId,
              items: _campaigns
                  .map<DropdownMenuItem<int>>(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.tenChienDich),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedCampaignId = v),
              validator: (v) => v == null ? 'Vui lòng chọn chiến dịch' : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _Input(
              controller: _ghiChuCtl,
              label: 'Lời nhắn cho chiến dịch (tuỳ chọn)',
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _SectionTitle('Tóm tắt đơn hàng'),
            ...cart.items.map((it) => _CartLine(item: it)),
            _SummaryRow('Tạm tính', _vnd(sub)),
            _SummaryRow.rich(
              left: Row(
                children: const [
                  Text('Đóng góp (10%)'),
                  SizedBox(width: 6),
                  Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppColors.secondary,
                    size: 18,
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

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : () => _submit(cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : const Text(
                      "Xác nhận thanh toán",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
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
      ).showSnackBar(const SnackBar(content: Text("Giỏ hàng đang trống")));
      return;
    }

    setState(() => _submitting = true);

    try {
      final trangThai = _paymentMethod == "momo" ? "SUCCESS" : "PENDING";

      final req = OrderRequest.fromCart(
        hoTen: _hoTenCtl.text.trim(),
        sdt: _sdtCtl.text.trim(),
        loinhan: _loiNhanCtl.text.trim(),
        diaChi: _diaChiCtl.text.trim(),
        ghiChu: _ghiChuCtl.text.trim(),
        cartItems: cart.items,
        loaiThanhToan: _paymentMethod,
        chienDichId: _selectedCampaignId,
      );

      final result = await OrderService.createOrder(
        req,
        trangThaiThanhToan: trangThai,
      );

      final prefs = await SharedPreferences.getInstance();

      if (_paymentMethod == "momo") {
        // ⚡ Hiện popup loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AlertDialog(
            backgroundColor: Colors.white,
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Đang chuyển hướng đến MoMo...",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );

        final momoUrl = await MomoService.createPayment(
          idOrder: result["id"]!,
          amount: cart.subTotal,
          type: "order",
        );

        await prefs.setDouble('last_donation_amount', cart.subTotal);
        await prefs.setInt('last_campaign_id', _selectedCampaignId!);

        Navigator.pop(context); // tắt popup

        if (momoUrl != null) {
          await MomoService.openUrl(momoUrl);
          cart.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không tạo được giao dịch MoMo.")),
          );
        }
      } else {
        cart.clear();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(id: result['id']),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi thanh toán: $e")));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

//------------------ Các widget phụ ------------------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTextStyles.h3),
    );
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
            "${ApiConfig.imgUrl}${item.product.anhChinh}",
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

//------------------ Format tiền ------------------

String _vnd(double x) {
  final s = x.toStringAsFixed(0);
  final withSep = s.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return "$withSep₫";
}
