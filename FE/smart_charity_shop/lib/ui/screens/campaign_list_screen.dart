import 'package:flutter/material.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import 'package:smart_charity_shop/models/campaign_model.dart';
import 'package:smart_charity_shop/services/campaign_service.dart';
import 'package:smart_charity_shop/ui/screens/campaign_detail_screen.dart';
import 'package:smart_charity_shop/ui/screens/donate_screen.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  bool _loading = true;
  String? _error;
  List<Campaign> _all = [];

  String _searchQuery = '';
  String _selectedStatus = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    try {
      final data = await CampaignService.fetchAll();
      setState(() {
        _all = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Campaign> _applyFilters() {
    var list = _all;

    // Lọc theo trạng thái
    if (_selectedStatus != 'Tất cả') {
      list = list.where((c) => c.trangThai == _selectedStatus).toList();
    }

    // Lọc theo tìm kiếm
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((c) {
        return c.tenChienDich.toLowerCase().contains(q) ||
            (c.moTa ?? '').toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // Trạng thái đang load
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Nếu lỗi
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text("Lỗi tải dữ liệu: $_error", textAlign: TextAlign.center),
        ),
      );
    }

    // Áp dụng bộ lọc
    final list = _applyFilters();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Chiến dịch thiện nguyện"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text("Không có chiến dịch phù hợp."))
                : RefreshIndicator(
                    onRefresh: _fetchCampaigns,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: list.length,
                      itemBuilder: (_, i) =>
                          _buildCampaignCard(context, list[i]),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    );
  }

  // Thanh tìm kiếm + lọc trạng thái
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.white,
      child: Column(
        children: [
          // 🔍 Ô tìm kiếm
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v.trim()),
            decoration: InputDecoration(
              hintText: "Tìm kiếm chiến dịch...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 🧭 Bộ lọc trạng thái
          Row(
            children: [
              const Text(
                "Trạng thái:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
                  DropdownMenuItem(
                    value: 'Đang diễn ra',
                    child: Text('Đang diễn ra'),
                  ),
                  DropdownMenuItem(
                    value: 'Sắp diễn ra',
                    child: Text('Sắp diễn ra'),
                  ),
                  DropdownMenuItem(
                    value: 'Đã kết thúc',
                    child: Text('Đã kết thúc'),
                  ),
                ],
                onChanged: (v) =>
                    setState(() => _selectedStatus = v ?? 'Tất cả'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Card hiển thị từng chiến dịch
  Widget _buildCampaignCard(BuildContext context, Campaign c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              "${ApiConfig.imgUrl}${c.hinhAnhChinh}" ??
                  "https://picsum.photos/seed/campaign${c.id}/400/250",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.tenChienDich,
                  style: AppTextStyles.h3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  c.moTa ?? "Không có mô tả",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: c.progress,
                  backgroundColor: Colors.grey[300],
                  color: AppColors.primary,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 6),
                Text(
                  "${_vnd(c.soTienHienTai)} / ${_vnd(c.mucTieu)}",
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      c.trangThai,
                      style: TextStyle(
                        color: c.trangThai == "Đã kết thúc"
                            ? Colors.red
                            : c.trangThai == "Sắp diễn ra"
                            ? Colors.orange
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CampaignDetailScreen(campaignId: c.id),
                              ),
                            );
                          },
                          child: const Text("Chi tiết"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonateScreen(campaignId: c.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          icon: const Icon(
                            Icons.volunteer_activism_rounded,
                            size: 18,
                          ),
                          label: const Text("Đóng góp"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
