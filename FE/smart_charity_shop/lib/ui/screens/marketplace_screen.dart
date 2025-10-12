import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_charity_shop/state/cart_provider.dart';
import 'package:smart_charity_shop/ui/screens/cart_screen.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';
import '/../models/category_model.dart';
import '/../models/product_model.dart';
import '/../services/category_service.dart';
import '/../services/product_service.dart';
import 'product_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  Future<List<Category>>? _catsFuture;
  Future<List<Product>>? _productsFuture;

  int? _selectedLoaiId;
  RangeValues _priceRange = const RangeValues(0, 2_000_000);
  String _q = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _catsFuture = CategoryService.fetchAll();
    _loadProducts();
  }

  void _loadProducts() {
    // Nếu BE có /ByLoai/{id} thì gọi fetchByLoai; nếu không thì fetchAll rồi lọc client.
    if (_selectedLoaiId != null) {
      _productsFuture = ProductService.fetchByLoai(_selectedLoaiId!);
    } else {
      _productsFuture = ProductService.fetchAll();
    }
    setState(() {});
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() => _q = v.trim());
    });
  }

  List<Product> _applyLocalFilters(List<Product> items) {
    // search
    var list = _q.isEmpty ? items : ProductService.searchLocal(items, _q);
    // price range
    list = list.where((p) {
      final g = p.gia;
      return g >= _priceRange.start && g <= _priceRange.end;
    }).toList();
    // if (_selectedLoaiId != null) {
    //   list = list.where((p) => p.loaiId == _selectedLoaiId).toList();
    // }
    return list;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Marketplace"),
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
      body: Column(
        children: [
          _SearchAndFilters(
            catsFuture: _catsFuture!,
            selectedLoaiId: _selectedLoaiId,
            onSelectLoai: (id) {
              _selectedLoaiId = id;
              _loadProducts();
            },
            priceRange: _priceRange,
            onPriceChanged: (rv) => setState(() => _priceRange = rv),
            onSearchChanged: _onSearchChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text("Lỗi tải sản phẩm: ${snap.error}"));
                }
                final items = _applyLocalFilters(snap.data ?? []);
                if (items.isEmpty) {
                  return const Center(
                    child: Text("Không có sản phẩm phù hợp."),
                  );
                }
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // responsive đơn giản
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final p = items[i];
                    return _ProductTile(
                      p: p,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: p),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  final Future<List<Category>> catsFuture;
  final int? selectedLoaiId;
  final ValueChanged<int?> onSelectLoai;
  final RangeValues priceRange;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<String> onSearchChanged;

  const _SearchAndFilters({
    required this.catsFuture,
    required this.selectedLoaiId,
    required this.onSelectLoai,
    required this.priceRange,
    required this.onPriceChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Tìm kiếm sản phẩm...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Category chips
        SizedBox(
          height: 46,
          child: FutureBuilder<List<Category>>(
            future: catsFuture,
            builder: (context, snap) {
              final chips = <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ChoiceChip(
                    label: const Text("Tất cả"),
                    selected: selectedLoaiId == null,
                    onSelected: (_) => onSelectLoai(null),
                  ),
                ),
              ];
              if (snap.connectionState == ConnectionState.waiting) {
                chips.add(
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                );
              } else if (snap.hasData) {
                chips.addAll(
                  snap.data!.map((c) {
                    final sel = selectedLoaiId == c.id;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(c.tenLoai),
                        selected: sel,
                        onSelected: (_) => onSelectLoai(c.id),
                      ),
                    );
                  }),
                );
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: chips,
              );
            },
          ),
        ),
        // Price range
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Row(
            children: [
              const Text("Khoảng giá"),
              Expanded(
                child: RangeSlider(
                  values: priceRange,
                  min: 0,
                  max: 10_000_000,
                  divisions: 100,
                  labels: RangeLabels(
                    _vnd(priceRange.start),
                    _vnd(priceRange.end),
                  ),
                  onChanged: onPriceChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product p;
  final VoidCallback onTap;
  const _ProductTile({required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: Image.network(
                  p.anhChinh ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFF2F2F2),
                    child: const Icon(Icons.image_not_supported_rounded),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
              child: Text(
                p.tenSanPham,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _vnd(p.gia),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: Text(
                p.tenLoai ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: Colors.grey),
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
