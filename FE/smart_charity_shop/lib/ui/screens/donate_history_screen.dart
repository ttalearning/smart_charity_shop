import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smart_charity_shop/services/donation_service.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';

import '../../configs/api_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class DonateHistoryScreen extends StatefulWidget {
  const DonateHistoryScreen({super.key});

  @override
  State<DonateHistoryScreen> createState() => _DonateHistoryScreenState();
}

class _DonateHistoryScreenState extends State<DonateHistoryScreen> {
  bool _loading = true;
  List<dynamic> _donations = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      print("⚠️ Không có userId");
      return;
    }

    final list = await DonationService.fetchMyDonations(userId);
    setState(() {
      _donations = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Lịch sử quyên góp"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _donations.isEmpty
          ? const Center(
              child: Text(
                "Bạn chưa có giao dịch quyên góp nào.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchHistory,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _donations.length,
                itemBuilder: (_, i) {
                  final d = _donations[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                d["chienDich"]?["tenChienDich"] ??
                                    "Chiến dịch #${d["chienDichId"]}",
                                style: AppTextStyles.h3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Số tiền: ${_vnd((d["soTien"] ?? 0).toDouble())}",
                          style: AppTextStyles.body.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ngày tạo: ${d["ngayTao"] ?? "Không rõ"}",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  );
                },
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
