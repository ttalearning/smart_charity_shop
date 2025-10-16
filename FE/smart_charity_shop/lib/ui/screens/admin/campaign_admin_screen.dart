import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import '../../../models/campaign_model.dart';
import '../../../services/campaign_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../services/upload_service.dart';

class CampaignAdminScreen extends StatefulWidget {
  const CampaignAdminScreen({super.key});

  @override
  State<CampaignAdminScreen> createState() => _CampaignAdminScreenState();
}

class _CampaignAdminScreenState extends State<CampaignAdminScreen> {
  List<Campaign> _campaigns = [];
  bool _loading = true;
  final ImagePicker _picker = ImagePicker();
  final _moneyFormat = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final campaigns = await CampaignService.fetchAll();
    setState(() {
      _campaigns = campaigns;
      _loading = false;
    });
  }

  Future<void> _deleteCampaign(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa chiến dịch này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) return;

    final success = await CampaignService.delete(id, token);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xóa chiến dịch.")));
      _loadData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Xóa thất bại.")));
    }
  }

  void _showForm({Campaign? campaign}) {
    final nameCtrl = TextEditingController(text: campaign?.tenChienDich ?? '');
    final descCtrl = TextEditingController(text: campaign?.moTa ?? '');
    final targetCtrl = TextEditingController(
      text: campaign != null ? campaign.mucTieu.toStringAsFixed(0) : '',
    );
    final locationCtrl = TextEditingController(text: campaign?.diaDiem ?? '');
    final startDateCtrl = TextEditingController(
      text: campaign?.ngayBatDau?.toLocal().toString().split(' ')[0] ?? '',
    );
    final endDateCtrl = TextEditingController(
      text: campaign?.ngayKetThuc?.toLocal().toString().split(' ')[0] ?? '',
    );

    DateTime? selectedStartDate = campaign?.ngayBatDau;
    DateTime? selectedEndDate = campaign?.ngayKetThuc;

    File? mainImageFile;
    String? mainImageUrl = campaign?.hinhAnhChinh;
    List<File> pickedExtraImages = [];
    List<String> existingExtraUrls = campaign?.hinhAnhs ?? [];

    Future<void> _pickMainImage() async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        mainImageFile = File(picked.path);
        mainImageUrl = null;
        setState(() {});
      }
    }

    Future<void> _pickExtraImages() async {
      final picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        pickedExtraImages.addAll(picked.map((e) => File(e.path)).toList());
        setState(() {});
      }
    }

    Future<void> _selectDate(BuildContext context, bool isStartDate) async {
      final picked = await showDatePicker(
        context: context,
        initialDate: isStartDate
            ? selectedStartDate ?? DateTime.now()
            : selectedEndDate ?? DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        if (isStartDate) {
          selectedStartDate = picked;
          startDateCtrl.text = picked.toString().split(' ')[0];
        } else {
          selectedEndDate = picked;
          endDateCtrl.text = picked.toString().split(' ')[0];
        }
        setState(() {});
      }
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              campaign == null ? "Thêm chiến dịch" : "Chỉnh sửa chiến dịch",
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Tên chiến dịch",
                    ),
                  ),
                  TextField(
                    controller: descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Mô tả"),
                  ),
                  TextField(
                    controller: targetCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Mục tiêu (VNĐ)",
                    ),
                  ),
                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(labelText: "Địa điểm"),
                  ),

                  // Ngày bắt đầu
                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: IgnorePointer(
                      child: TextField(
                        controller: startDateCtrl,
                        decoration: const InputDecoration(
                          labelText: "Ngày bắt đầu",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  // Ngày kết thúc
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: IgnorePointer(
                      child: TextField(
                        controller: endDateCtrl,
                        decoration: const InputDecoration(
                          labelText: "Ngày kết thúc",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ảnh chính
                  Text("Ảnh chính", style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      await _pickMainImage();
                      setDialogState(() {});
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: mainImageFile != null
                          ? Image.file(mainImageFile!, fit: BoxFit.cover)
                          : (mainImageUrl != null && mainImageUrl!.isNotEmpty)
                          ? Image.network(
                              "${ApiConfig.imgUrl}$mainImageUrl",
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                                size: 48,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ảnh phụ
                  Text("Ảnh phụ", style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...existingExtraUrls.map(
                        (url) => Stack(
                          children: [
                            Image.network(
                              "${ApiConfig.imgUrl}$url",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setDialogState(
                                  () => existingExtraUrls.remove(url),
                                ),
                                child: _deleteIcon(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...pickedExtraImages.map(
                        (img) => Stack(
                          children: [
                            Image.file(
                              img,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => setDialogState(
                                  () => pickedExtraImages.remove(img),
                                ),
                                child: _deleteIcon(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _pickExtraImages();
                          setDialogState(() {});
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.grey,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isEmpty) {
                    _showSnack("Tên chiến dịch không được để trống");
                    return;
                  }
                  if (targetCtrl.text.isEmpty ||
                      double.tryParse(targetCtrl.text) == null) {
                    _showSnack("Vui lòng nhập mục tiêu hợp lệ");
                    return;
                  }
                  if (selectedStartDate == null || selectedEndDate == null) {
                    _showSnack("Vui lòng chọn ngày bắt đầu và kết thúc");
                    return;
                  }

                  // Upload ảnh chính
                  String hinhAnhChinh = mainImageUrl ?? "";
                  if (mainImageFile != null) {
                    final uploaded = await UploadService.uploadImage(
                      mainImageFile!,
                      type: "campaign",
                    );
                    if (uploaded != null) hinhAnhChinh = uploaded;
                  }

                  // Upload ảnh phụ
                  List<String> hinhAnhs = [...existingExtraUrls];
                  for (final imgFile in pickedExtraImages) {
                    final uploaded = await UploadService.uploadImage(
                      imgFile,
                      type: "campaign",
                    );
                    if (uploaded != null) hinhAnhs.add(uploaded);
                  }

                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('jwt_token');
                  if (token == null) return;

                  final campaignData = {
                    "tenChienDich": nameCtrl.text.trim(),
                    "moTa": descCtrl.text.trim(),
                    "mucTieu": double.parse(targetCtrl.text),
                    "diaDiem": locationCtrl.text.trim(),
                    "ngayBatDau": selectedStartDate!.toIso8601String(),
                    "ngayKetThuc": selectedEndDate!.toIso8601String(),
                    "hinhAnhChinh": hinhAnhChinh,
                    "hinhAnhs": hinhAnhs
                        .map((url) => {"url": url, "isChinh": false})
                        .toList(),
                  };

                  bool success;
                  if (campaign == null) {
                    success = await CampaignService.create(campaignData, token);
                  } else {
                    success = await CampaignService.update(
                      campaign.id,
                      campaignData,
                      token,
                    );
                  }

                  if (success && mounted) {
                    Navigator.pop(context);
                    _loadData();
                    _showSnack(
                      campaign == null
                          ? "Đã thêm chiến dịch."
                          : "Cập nhật thành công.",
                    );
                  } else {
                    _showSnack("Thao tác thất bại.");
                  }
                },
                child: const Text("Lưu"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _deleteIcon() => Container(
    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    padding: const EdgeInsets.all(4),
    child: const Icon(Icons.close, size: 16, color: Colors.white),
  );

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý chiến dịch"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _campaigns.length,
                itemBuilder: (_, i) {
                  final c = _campaigns[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "${ApiConfig.imgUrl}${c.hinhAnhChinh}",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                      title: Text(c.tenChienDich),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${c.ngayBatDau?.toString().split(' ')[0] ?? 'Chưa đặt'} — ${c.ngayKetThuc?.toString().split(' ')[0] ?? 'Chưa đặt'}",
                          ),
                          LinearProgressIndicator(
                            value: c.progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                          Text(
                            "${_moneyFormat.format(c.soTienHienTai)}/${_moneyFormat.format(c.mucTieu)} VNĐ",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showForm(campaign: c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCampaign(c.id),
                          ),
                        ],
                      ),
                      children: [
                        if (c.moTa?.isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(c.moTa!),
                          ),
                        if (c.hinhAnhs.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: c.hinhAnhs
                                  .map(
                                    (url) => Image.network(
                                      "${ApiConfig.imgUrl}$url",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
