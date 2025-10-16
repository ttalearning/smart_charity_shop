import 'package:flutter/material.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import 'package:smart_charity_shop/models/campaign_model.dart';
import 'package:smart_charity_shop/models/donation_model.dart';
import 'package:smart_charity_shop/services/campaign_service.dart';
import 'package:smart_charity_shop/services/donation_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'donate_screen.dart';

class CampaignDetailScreen extends StatefulWidget {
  final int campaignId;
  const CampaignDetailScreen({super.key, required this.campaignId});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  late Future<Campaign?> _future;
  String? _currentMainImage;

  @override
  void initState() {
    super.initState();
    _future = CampaignService.fetchById(widget.campaignId);
  }

  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "${ApiConfig.imgUrl}${imageUrl ?? ''}",
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Chi tiết chiến dịch"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Campaign?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snap.error}"));
          }

          final c = snap.data;
          if (c == null) {
            return const Center(child: Text("Không tìm thấy chiến dịch"));
          }

          _currentMainImage ??= c.hinhAnhChinh;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ảnh chính
              GestureDetector(
                onTap: () {
                  if (_currentMainImage != null) {
                    _showFullImage(_currentMainImage!);
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "${ApiConfig.imgUrl}${_currentMainImage ?? ''}" ??
                        "https://picsum.photos/seed/campaign${c.id}/400/250",
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: const Color(0xFFF2F2F2),
                      child: const Icon(Icons.image_not_supported, size: 48),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tên + mô tả
              Text(c.tenChienDich, style: AppTextStyles.h2),
              const SizedBox(height: 6),
              if (c.diaDiem != null && c.diaDiem!.isNotEmpty)
                Text(
                  "Địa điểm: ${c.diaDiem}",
                  style: AppTextStyles.caption.copyWith(color: Colors.grey),
                ),
              const SizedBox(height: 8),

              // Thanh tiến độ
              LinearProgressIndicator(
                value: c.progress,
                color: AppColors.primary,
                backgroundColor: Colors.grey[300],
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                "Đã quyên góp: ${_vnd(c.soTienHienTai)} / ${_vnd(c.mucTieu)}",
                style: AppTextStyles.bodyBold,
              ),
              const Divider(height: 24),

              // Mô tả
              if (c.moTa != null && c.moTa!.isNotEmpty)
                Text(c.moTa!, style: AppTextStyles.body),
              const SizedBox(height: 16),

              // Ảnh phụ
              if (c.hinhAnhs.isNotEmpty) ...[
                Text("Hình ảnh hoạt động", style: AppTextStyles.h3),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.hinhAnhs.length,
                    itemBuilder: (_, i) {
                      final url = c.hinhAnhs[i];
                      return GestureDetector(
                        onTap: () => setState(() => _currentMainImage = url),
                        onLongPress: () => _showFullImage(url),
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentMainImage == url
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "${ApiConfig.imgUrl}${url ?? ''}",
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF2F2F2),
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const Divider(height: 32),

              // Lịch sử đóng góp
              Text("Lịch sử đóng góp", style: AppTextStyles.h3),
              const SizedBox(height: 8),
              FutureBuilder<List<Donation>>(
                future: DonationService.fetchByCampaign(c.id),
                builder: (context, snap2) {
                  if (snap2.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  if (snap2.hasError) {
                    return Text("Lỗi tải donate: ${snap2.error}");
                  }
                  final list = snap2.data ?? [];
                  if (list.isEmpty) {
                    return const Text("Chưa có ai đóng góp.");
                  }
                  return Column(
                    children: list.map((d) {
                      return ListTile(
                        leading: const Icon(
                          Icons.volunteer_activism_rounded,
                          color: AppColors.secondary,
                        ),
                        title: Text(d.tenNguoiDung),
                        subtitle: Text(
                          _vnd(d.soTien),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          "${d.ngayTao.day}/${d.ngayTao.month}/${d.ngayTao.year}",
                          style: AppTextStyles.caption,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 90),
            ],
          );
        },
      ),

      // 👉 Nút Quyên góp ngay
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DonateScreen(campaignId: widget.campaignId),
                ),
              );
            },
            icon: const Icon(Icons.volunteer_activism_rounded),
            label: const Text("Quyên góp ngay"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: AppTextStyles.bodyBold,
            ),
          ),
        ),
      ),
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
}
