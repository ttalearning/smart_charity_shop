import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_charity_shop/ui/screens/checkout_screen.dart';
import '/../state/cart_provider.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: cart.clear,
              child: const Text(
                'Xoá hết',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomSummary(
        subTotal: cart.subTotal,
        donation10: cart.donation10,
        onCheckout: () {
          final cart = context.read<CartProvider>();

          if (cart.items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Giỏ hàng của bạn đang trống!')),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CheckoutScreen()),
          );
        },
      ),
      body: cart.items.isEmpty
          ? const _EmptyView()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final it = cart.items[i];
                return _CartTile(item: it);
              },
            ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text("Giỏ hàng trống", style: AppTextStyles.body),
          const SizedBox(height: 4),
          Text(
            "Thêm vài món tử tế nào 💚",
            style: AppTextStyles.caption.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ảnh
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              item.product.anhChinh ?? "",
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 90,
                color: const Color(0xFFF2F2F2),
                child: const Icon(Icons.image_not_supported_rounded),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.tenSanPham,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _vnd(item.product.gia),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyBtn(
                        icon: Icons.remove_rounded,
                        onTap: () => cart.setQuantity(
                          item.product.id,
                          item.quantity - 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "${item.quantity}",
                          style: AppTextStyles.body,
                        ),
                      ),
                      _QtyBtn(
                        icon: Icons.add_rounded,
                        onTap: () => cart.setQuantity(
                          item.product.id,
                          item.quantity + 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Xoá
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => cart.remove(item.product.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _BottomSummary extends StatelessWidget {
  final double subTotal;
  final double donation10;
  final VoidCallback onCheckout;

  const _BottomSummary({
    required this.subTotal,
    required this.donation10,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final total = subTotal; // nếu còn phí ship/giảm giá, cộng thêm ở đây
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _row("Tạm tính", _vnd(subTotal)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Đóng góp (10%)"),
                Row(
                  children: [
                    const Icon(
                      Icons.volunteer_activism_rounded,
                      size: 18,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _vnd(donation10),
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 18),
            _rowBold("Tổng thanh toán", _vnd(total)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Thanh toán"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String l, String r) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(l), Text(r)],
  );

  Widget _rowBold(String l, String r) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: AppTextStyles.bodyBold),
      Text(r, style: AppTextStyles.bodyBold),
    ],
  );
}

String _vnd(double x) {
  final s = x.toStringAsFixed(0);
  final withSep = s.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return "$withSep₫";
}
