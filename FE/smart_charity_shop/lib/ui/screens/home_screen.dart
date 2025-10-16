import 'package:flutter/material.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import 'package:smart_charity_shop/models/campaign_model.dart';
import 'package:smart_charity_shop/models/category_model.dart';
import 'package:smart_charity_shop/models/product_model.dart';
import 'package:smart_charity_shop/services/campaign_service.dart';
import 'package:smart_charity_shop/services/category_service.dart';
import 'package:smart_charity_shop/services/product_service.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 🔍 Search AppBar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tìm kiếm chiến dịch...',
                        style: AppTextStyles.body.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            // 📄 Nội dung chính
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HeroBannerInspire(),
                  SizedBox(height: 16),
                  _StatsSection(),
                  SizedBox(height: 12),
                  _SectionHeader(
                    title: "Chiến dịch nổi bật",
                    actionLabel: "Xem tất cả",
                  ),
                  _CampaignHighlight(),
                  SizedBox(height: 20),
                  _HeroBannerShop(),
                  SizedBox(height: 20),
                  _SectionHeader(title: "Danh mục nổi bật"),
                  _CategoryList(),
                  SizedBox(height: 20),
                  _SectionHeader(title: "Sản phẩm mới"),
                  _ProductList(),
                  SizedBox(height: 20),

                  _QuickActions(),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// 🏞️ HERO BANNER #1: Truyền cảm hứng
//
class _HeroBannerInspire extends StatelessWidget {
  const _HeroBannerInspire();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primary.withOpacity(0.85),
              AppColors.tertiary.withOpacity(0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              "Chung tay vì cộng đồng 💚",
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Minh bạch – Uy tín – Tận tâm",
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility_rounded, size: 10),
                label: const Text("Xem chiến dịch"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// 📊 Thống kê tổng hợp
//
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        "icon": Icons.campaign_rounded,
        "value": "42",
        "label": "Chiến dịch",
        "color": AppColors.primary,
      },
      {
        "icon": Icons.volunteer_activism_rounded,
        "value": "₫1.2T",
        "label": "Đã quyên góp",
        "color": AppColors.secondary,
      },
      {
        "icon": Icons.people_alt_rounded,
        "value": "5,432",
        "label": "Người tham gia",
        "color": AppColors.tertiary,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stats.map((s) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (s["color"] as Color).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (s["color"] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      s["icon"] as IconData,
                      color: s["color"] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(s["value"] as String, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text(
                    s["label"] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

//
// 🎯 Chiến dịch nổi bật
//
class _CampaignHighlight extends StatefulWidget {
  const _CampaignHighlight();

  @override
  State<_CampaignHighlight> createState() => _CampaignHighlightState();
}

class _CampaignHighlightState extends State<_CampaignHighlight> {
  late Future<List<Campaign>> _campaignsFuture;

  @override
  void initState() {
    super.initState();
    _campaignsFuture = CampaignService.fetchFeatured();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Campaign>>(
      future: _campaignsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chiến dịch nào nổi bật.'));
        }

        final campaigns = snapshot.data!;
        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: campaigns.length,
            itemBuilder: (_, i) {
              final c = campaigns[i];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        c.hinhAnhChinh != null
                            ? "${ApiConfig.imgUrl}${c.hinhAnhChinh}"
                            : 'https://picsum.photos/400/300',
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.tenChienDich, style: AppTextStyles.bodyBold),
                          const SizedBox(height: 4),
                          Text(
                            c.moTa ?? 'Không có mô tả',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: c.progress,
                              minHeight: 6,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

//
// 🛍️ HERO BANNER #2
//
class _HeroBannerShop extends StatelessWidget {
  const _HeroBannerShop();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mua sắm tử tế 🛍️",
                  style: AppTextStyles.h2.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 6),
                Text(
                  "10% mỗi đơn hàng được trích vào quỹ thiện nguyện.",
                  style: AppTextStyles.body.copyWith(color: Colors.grey[700]),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("Khám phá ngay →"),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.volunteer_activism_rounded,
            size: 64,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

//
// 🧩 Danh mục
//
class _CategoryList extends StatefulWidget {
  const _CategoryList();

  @override
  State<_CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<_CategoryList> {
  late Future<List<Category>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = CategoryService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có danh mục nào.'));
        }

        final categories = snapshot.data!;
        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final item = categories[i];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.category_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(item.tenLoai ?? '', style: AppTextStyles.caption),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

//
// 🛒 Sản phẩm mới
//
class _ProductList extends StatefulWidget {
  const _ProductList();

  @override
  State<_ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<_ProductList> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm.'));
        }

        final products = snapshot.data!;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            itemBuilder: (_, i) {
              final item = products[i];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        item.anhChinh ?? '',
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image, size: 60),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.tenSanPham ?? '',
                            style: AppTextStyles.bodyBold,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${item.gia ?? 0}₫",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

//
// ⚡ Quick Actions
//
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {"icon": Icons.shopping_bag_rounded, "label": "Mua hàng"},
      {"icon": Icons.volunteer_activism_rounded, "label": "Gây quỹ"},
      {"icon": Icons.campaign_rounded, "label": "Chiến dịch"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 16,
        runSpacing: 16,
        children: actions.map((a) {
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(a["icon"] as IconData, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(a["label"] as String, style: AppTextStyles.caption),
            ],
          );
        }).toList(),
      ),
    );
  }
}

//
// 🏷️ Section Header
//
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.actionLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h2),
          if (actionLabel != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                actionLabel!,
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
