import 'package:flutter/material.dart';
import 'package:smart_charity_shop/models/campaign_model.dart';
import 'package:smart_charity_shop/models/category_model.dart';
import 'package:smart_charity_shop/models/product_model.dart';
import 'package:smart_charity_shop/services/campaign_service.dart';
import 'package:smart_charity_shop/services/category_service.dart';
import 'package:smart_charity_shop/services/product_service.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroBannerInspire(),

              const SizedBox(height: 12),
              const _StatsSection(),

              const SizedBox(height: 12),
              _SectionHeader(
                title: "Chiến dịch nổi bật",
                actionLabel: "Xem tất cả",
                onTap: () {},
              ),
              const _CampaignHighlight(),

              const SizedBox(height: 20),
              const _HeroBannerShop(),

              const SizedBox(height: 20),
              _SectionHeader(title: "Danh mục nổi bật"),
              const _CategoryList(),

              const SizedBox(height: 20),
              _SectionHeader(title: "Sản phẩm mới"),
              const MyWidget(),

              const SizedBox(height: 20),
              const _ChatbotCard(),

              const SizedBox(height: 24),
              const _QuickActions(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
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
      height: 200,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 0,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.favorite_rounded,
                size: 180,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lan tỏa yêu thương 💚",
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                "Gây quỹ dễ dàng – Minh bạch – Uy tín",
                style: AppTextStyles.body.copyWith(color: Colors.white70),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Xem chiến dịch"),
              ),
            ],
          ),
        ],
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
      {"icon": Icons.campaign_rounded, "value": "42", "label": "Chiến dịch"},
      {
        "icon": Icons.volunteer_activism_rounded,
        "value": "₫1.2T",
        "label": "Đã quyên góp",
      },
      {
        "icon": Icons.people_alt_rounded,
        "value": "5,432",
        "label": "Người tham gia",
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                children: [
                  Icon(
                    s["icon"] as IconData,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s["value"] as String,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    s["label"] as String,
                    style: AppTextStyles.caption.copyWith(color: Colors.grey),
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
  const _CampaignHighlight({super.key});

  @override
  State<_CampaignHighlight> createState() => __CampaignHighlightState();
}

class __CampaignHighlightState extends State<_CampaignHighlight> {
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
          return Center(
            child: Text(
              'Lỗi khi tải dữ liệu: ${snapshot.error}',
              style: AppTextStyles.caption,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chiến dịch nào nổi bật.'));
        }

        final campaigns = snapshot.data!;

        return SizedBox(
          height: 240,
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
                        c.hinhAnhChinh ?? 'https://picsum.photos/400/300',
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.tenChienDich, style: AppTextStyles.bodyBold),
                          const SizedBox(height: 4),
                          Text(
                            c.moTa ?? 'kh có',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(height: 6),
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
// 🛍️ HERO BANNER #2: Mua sắm tử tế
//
class _HeroBannerShop extends StatelessWidget {
  const _HeroBannerShop();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
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
                  "Mỗi đơn hàng đều đóng góp 10% vào quỹ thiện nguyện.",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.grey.shade700,
                  ),
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
            size: 70,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _CategoryList extends StatefulWidget {
  const _CategoryList({super.key});

  @override
  State<_CategoryList> createState() => __CategoryListState();
}

class __CategoryListState extends State<_CategoryList> {
  late Future<List<Category>> _categorys;

  void initState() {
    super.initState();
    _categorys = CategoryService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _categorys,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Lỗi khi tải dữ liệu: ${snapshot.error}',
              style: AppTextStyles.caption,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có danh mục nào.'));
        }

        final categorys = snapshot.data!;

        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categorys.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final item = categorys[i];
              return Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(Icons.checkroom, color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(item.tenLoai as String, style: AppTextStyles.caption),
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
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
          return Center(
            child: Text(
              'Lỗi khi tải dữ liệu: ${snapshot.error}',
              style: AppTextStyles.caption,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào.'));
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
                        item.anhChinh ?? '', // tránh null
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.tenSanPham ?? '',
                            style: AppTextStyles.bodyBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${item.gia ?? 0}₫",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
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

class _ProductCarousel extends StatelessWidget {
  const _ProductCarousel();

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      5,
      (i) => {
        "title": "Sản phẩm #$i",
        "price": 250000 + (i * 10000),
        "image": "https://picsum.photos/seed/item$i/400/300",
      },
    );

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
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
                    item["image"] as String,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] as String,
                        style: AppTextStyles.bodyBold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${item["price"]}₫",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
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
  }
}

//
// 🤖 Chatbot Card
//
class _ChatbotCard extends StatelessWidget {
  const _ChatbotCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: const Icon(Icons.chat_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Trò chuyện với SmartBot 🤖\nHỏi nhanh về chiến dịch, hướng dẫn sử dụng, hoặc tóm tắt thông tin.",
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
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
      {"icon": Icons.smart_toy_rounded, "label": "Chatbot"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 16,
        runSpacing: 16,
        children: actions.map((a) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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
// 🏷️ Section Header helper
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
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
