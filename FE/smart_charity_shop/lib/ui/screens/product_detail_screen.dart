import 'package:flutter/material.dart';
import 'package:smart_charity_shop/ui/screens/cart_screen.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';
import '/../models/product_model.dart';
import '/../services/product_service.dart';
import 'package:provider/provider.dart';
import '/../state/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String? campaignName;
  const ProductDetailScreen({
    super.key,
    required this.product,
    this.campaignName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<List<Product>> _relatedFuture;

  @override
  void initState() {
    super.initState();
    // lấy sản phẩm liên quan cùng loại (trừ chính nó)
    _relatedFuture = ProductService.fetchByLoai(
      widget.product.loaiId,
    ).then((list) => list.where((e) => e.id != widget.product.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final donate10 = (p.gia * 0.10);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(p.tenSanPham),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Consumer<CartProvider>(
                  builder: (_, cart, __) => cart.totalQuantity == 0
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.totalQuantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cart.totalQuantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: _BottomBar(
        price: p.gia,
        onAddToCart: () {
          context.read<CartProvider>().add(p);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Đã thêm vào giỏ")));
        },
        onBuyNow: () {
          context.read<CartProvider>().add(p);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Ảnh
          AspectRatio(
            aspectRatio: 1.3,
            child: Image.network(
              p.anhChinh ?? "",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF2F2F2),
                child: const Icon(Icons.image_not_supported_rounded, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tiêu đề + giá + danh mục
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(p.tenSanPham, style: AppTextStyles.h2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Text(
                  _vnd(p.gia),
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                if (p.tenLoai != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(p.tenLoai!, style: AppTextStyles.caption),
                  ),
              ],
            ),
          ),

          // Seller (placeholder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: const Icon(
                    Icons.store_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Nhà bán uy tín • Điểm thiện nguyện 1,240",
                    style: AppTextStyles.body,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("Xem hồ sơ")),
              ],
            ),
          ),

          // Banner 10% đóng góp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.volunteer_activism_rounded,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.campaignName == null
                          ? "10% giá trị hoá đơn sẽ được quyên góp cho quỹ thiện nguyện."
                          : "10% giá trị hoá đơn sẽ đóng góp cho chiến dịch “${widget.campaignName}”.",
                      style: AppTextStyles.body,
                    ),
                  ),
                  Text(
                    _vnd(donate10),
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mô tả
          if (p.moTa != null && p.moTa!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Mô tả", style: AppTextStyles.h3),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: Text(p.moTa!, style: AppTextStyles.body),
            ),
          ],

          // Sản phẩm liên quan
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sản phẩm liên quan", style: AppTextStyles.h3),
                TextButton(onPressed: () {}, child: const Text("Xem thêm")),
              ],
            ),
          ),
          FutureBuilder<List<Product>>(
            future: _relatedFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError || (snap.data?.isEmpty ?? true)) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Chưa có sản phẩm liên quan."),
                );
              }
              final rel = snap.data!;
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: rel.length,
                  itemBuilder: (_, i) {
                    final rp = rel[i];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: rp),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1.2,
                                child: Image.network(
                                  rp.anhChinh ?? "",
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFFF2F2F2),
                                    child: const Icon(
                                      Icons.image_not_supported_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                              child: Text(
                                rp.tenSanPham,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyBold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                _vnd(rp.gia),
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 90),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _BottomBar({
    required this.price,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onAddToCart,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Thêm vào giỏ"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Mua ngay • ${_vnd(price)}"),
              ),
            ),
          ],
        ),
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
