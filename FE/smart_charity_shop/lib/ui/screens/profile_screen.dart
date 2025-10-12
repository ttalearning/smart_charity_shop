import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/ui/screens/auth/login_screen.dart';
import 'package:smart_charity_shop/ui/screens/order_detail_screen.dart';
import 'package:smart_charity_shop/ui/widgets/custom_bottom_nav.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../services/auth_service.dart';
import '../../../services/order_service.dart';
import '../../../services/donation_service.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _email;
  List<dynamic> _orders = [];
  List<dynamic> _donations = [];
  bool _loading = true;

  int _visibleOrderCount = 5;
  int _visibleDonationCount = 5;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? "Người dùng";
    final email = prefs.getString('user_email') ?? "example@email.com";
    final userId = prefs.getInt('user_id') ?? 0;
    final orders = await OrderService.fetchMyOrders();
    final donations = await DonationService.fetchMyDonations(userId);

    setState(() {
      _userName = name;
      _email = email;
      _orders = orders;
      _donations = donations;
      _loading = false;
      _visibleOrderCount = 5;
      _visibleDonationCount = 5;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _orders.take(_visibleOrderCount).toList();
    final visibleDonations = _donations.take(_visibleDonationCount).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tài khoản của tôi"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUser,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildActionTile(
                    icon: Icons.lock_reset_rounded,
                    title: "Đổi mật khẩu",
                    onTap: _showChangePasswordDialog,
                  ),

                  // -----------------------
                  // ĐƠN HÀNG
                  // -----------------------
                  _buildSectionTitle("Đơn hàng của bạn"),
                  _orders.isEmpty
                      ? const Text("Chưa có đơn hàng nào.")
                      : Column(
                          children: [
                            ...visibleOrders
                                .map((o) => _OrderTile(order: o))
                                .toList(),
                            if (_orders.length > 5)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _visibleOrderCount =
                                            (_visibleOrderCount + 5).clamp(
                                              5,
                                              _orders.length,
                                            );
                                      });
                                    },
                                    icon: const Icon(Icons.expand_more),
                                    label: const Text("Xem thêm"),
                                  ),
                                  if (_visibleOrderCount > 5)
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _visibleOrderCount =
                                              (_visibleOrderCount - 5).clamp(
                                                5,
                                                _orders.length,
                                              );
                                        });
                                      },
                                      icon: const Icon(Icons.expand_less),
                                      label: const Text("Thu gọn"),
                                    ),
                                ],
                              ),
                          ],
                        ),

                  const SizedBox(height: 16),

                  // -----------------------
                  // LỊCH SỬ QUYÊN GÓP
                  // -----------------------
                  _buildSectionTitle("Lịch sử quyên góp"),
                  _donations.isEmpty
                      ? const Text("Bạn chưa thực hiện quyên góp nào.")
                      : Column(
                          children: [
                            ...visibleDonations
                                .map((d) => _DonationTile(donation: d))
                                .toList(),
                            if (_donations.length > 5)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _visibleDonationCount =
                                            (_visibleDonationCount + 5).clamp(
                                              5,
                                              _donations.length,
                                            );
                                      });
                                    },
                                    icon: const Icon(Icons.expand_more),
                                    label: const Text("Xem thêm"),
                                  ),
                                  if (_visibleDonationCount > 5)
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _visibleDonationCount =
                                              (_visibleDonationCount - 5).clamp(
                                                5,
                                                _donations.length,
                                              );
                                        });
                                      },
                                      icon: const Icon(Icons.expand_less),
                                      label: const Text("Thu gọn"),
                                    ),
                                ],
                              ),
                          ],
                        ),

                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("Đăng xuất"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userName!, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Text(_email!, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: AppTextStyles.h3),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Đổi mật khẩu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldCtrl,
              decoration: const InputDecoration(labelText: "Mật khẩu cũ"),
              obscureText: true,
            ),
            TextField(
              controller: newCtrl,
              decoration: const InputDecoration(labelText: "Mật khẩu mới"),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await AuthService.changePassword(
                oldCtrl.text,
                newCtrl.text,
              );
              if (success && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đổi mật khẩu thành công!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đổi mật khẩu thất bại.")),
                );
              }
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }
}

//---------------- ĐƠN HÀNG ----------------
class _OrderTile extends StatelessWidget {
  final dynamic order;
  const _OrderTile({required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "thành công":
        return Colors.green;
      case "đang xử lý":
        return Colors.orange;
      case "đã hủy":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: order["id"]),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ID + Trạng thái ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đơn hàng #${order["id"]}",
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      order["trangThaiThanhToan"],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order["trangThaiThanhToan"] ?? "Không rõ",
                    style: TextStyle(
                      color: _getStatusColor(order["trangThaiThanhToan"]),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // --- Ngày tạo ---
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  order["createdAt"] != null
                      ? dateFormat.format(DateTime.parse(order["createdAt"]))
                      : "Không rõ ngày",
                  style: AppTextStyles.body.copyWith(color: Colors.grey),
                ),
              ],
            ),

            const Divider(height: 20),

            // --- Tổng tiền ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng tiền hàng",
                  style: AppTextStyles.body.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  currency.format(order["tongTienHang"] ?? 0),
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//---------------- QUYÊN GÓP ----------------
class _DonationTile extends StatelessWidget {
  final dynamic donation;
  const _DonationTile({required this.donation});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tên chiến dịch ---
          Row(
            children: [
              const Icon(
                Icons.volunteer_activism_outlined,
                color: Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  donation["tenChienDich"] ?? "Chiến dịch không xác định",
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // --- Ngày tạo ---
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                donation["ngayTao"] != null
                    ? dateFormat.format(DateTime.parse(donation["ngayTao"]))
                    : "Không rõ ngày",
                style: AppTextStyles.body.copyWith(color: Colors.grey),
              ),
            ],
          ),

          const Divider(height: 20),

          // --- Số tiền ủng hộ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Số tiền đóng góp",
                style: AppTextStyles.body.copyWith(color: Colors.grey.shade700),
              ),
              Text(
                currency.format(donation["soTien"] ?? 0),
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.secondary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
