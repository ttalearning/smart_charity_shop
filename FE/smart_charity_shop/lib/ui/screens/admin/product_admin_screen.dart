import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/configs/api_config.dart';
import '../../../models/product_model.dart';
import '../../../models/category_model.dart';
import '../../../services/product_service.dart';
import '../../../services/category_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../services/upload_service.dart';

class ProductAdminScreen extends StatefulWidget {
  const ProductAdminScreen({super.key});

  @override
  State<ProductAdminScreen> createState() => _ProductAdminScreenState();
}

class _ProductAdminScreenState extends State<ProductAdminScreen> {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _loading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await ProductService.fetchAll();
    final cats = await CategoryService.fetchAll();
    setState(() {
      _products = products;
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
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
    final success = await ProductService.delete(id, token!);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xóa sản phẩm.")));
      _loadData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Xóa thất bại.")));
    }
  }

  void _showForm({Product? product}) {
    final nameCtrl = TextEditingController(text: product?.tenSanPham);
    final priceCtrl = TextEditingController(
      text: product?.gia.toString() ?? "",
    );
    final descCtrl = TextEditingController(text: product?.moTa);

    Category? selectedCategory = _categories.firstWhere(
      (c) => c.id == product?.loaiId,
      orElse: () => _categories.isNotEmpty
          ? _categories.first
          : Category(id: 0, tenLoai: '', soSanPham: 0, isActive: true),
    );

    // 🖼 Ảnh chính và ảnh phụ
    File? mainImageFile;
    String? mainImageUrl = product?.anhChinh;
    List<File> pickedExtraImages = [];
    List<String> existingExtraUrls =
        product?.hinhAnhs.map((h) => h.url).toList() ?? [];

    Future<void> _pickMainImage() async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        mainImageFile = File(picked.path);
        mainImageUrl = null; // Xóa link cũ
      }
    }

    Future<void> _pickExtraImages() async {
      final picked = await _picker.pickMultiImage();
      if (picked.isNotEmpty) {
        pickedExtraImages.addAll(picked.map((e) => File(e.path)).toList());
      }
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(product == null ? "Thêm sản phẩm" : "Chỉnh sửa sản phẩm"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Tên sản phẩm"),
                ),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Giá"),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Mô tả"),
                ),
                const SizedBox(height: 16),

                // 🔹 Ảnh chính
                Text("Ảnh chính", style: AppTextStyles.h2),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await _pickMainImage();
                    setStateDialog(() {});
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
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  mainImageFile!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setStateDialog(() {
                                        mainImageFile = null;
                                        mainImageUrl = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : (mainImageUrl != null && mainImageUrl!.isNotEmpty)
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${ApiConfig.imgUrl}$mainImageUrl",
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setStateDialog(() {
                                        mainImageUrl = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
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

                // 🔹 Dropdown loại
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem<Category>(
                          value: c,
                          child: Text(c.tenLoai),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setStateDialog(() => selectedCategory = val),
                  decoration: const InputDecoration(labelText: "Loại sản phẩm"),
                ),

                const SizedBox(height: 20),

                // 🔹 Ảnh phụ
                Text("Ảnh phụ", style: AppTextStyles.h2),
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
                              onTap: () {
                                setStateDialog(
                                  () => existingExtraUrls.remove(url),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
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
                              onTap: () {
                                setStateDialog(
                                  () => pickedExtraImages.remove(img),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await _pickExtraImages();
                        setStateDialog(() {});
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tên sản phẩm không được để trống."),
                    ),
                  );
                  return;
                }

                // 🟩 Upload ảnh chính nếu có file mới
                String anhChinhUrl = mainImageUrl ?? "";
                if (mainImageFile != null) {
                  final uploaded = await UploadService.uploadImage(
                    mainImageFile!,
                    type: "product",
                  );
                  if (uploaded != null) anhChinhUrl = uploaded;
                }

                // 🟩 Upload ảnh phụ
                List<String> hinhAnhs = [...existingExtraUrls];
                for (final imgFile in pickedExtraImages) {
                  final uploaded = await UploadService.uploadImage(
                    imgFile,
                    type: "product",
                  );
                  if (uploaded != null) hinhAnhs.add(uploaded);
                }

                final productData = {
                  "tenSanPham": nameCtrl.text,
                  "gia": double.tryParse(priceCtrl.text) ?? 0,
                  "moTa": descCtrl.text,
                  "anhChinh": anhChinhUrl,
                  "loaiId": selectedCategory!.id,
                  "hinhAnhs": hinhAnhs,
                };

                bool success;
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('jwt_token');

                if (product == null) {
                  success = await ProductService.create(productData, token!);
                } else {
                  success = await ProductService.update(
                    product.id,
                    productData,
                    token!,
                  );
                }

                if (success && mounted) {
                  Navigator.pop(context);
                  _loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        product == null
                            ? "Đã thêm sản phẩm."
                            : "Cập nhật thành công.",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thao tác thất bại.")),
                  );
                }
              },
              child: const Text("Lưu"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sản phẩm"),
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
                itemCount: _products.length,
                itemBuilder: (_, i) {
                  final p = _products[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (p.anhChinh != null && p.anhChinh!.isNotEmpty)
                            ? Image.network(
                                "${ApiConfig.imgUrl}${p.anhChinh!}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported, size: 40),
                      ),
                      title: Text(p.tenSanPham),
                      subtitle: Text(
                        "${p.gia.toStringAsFixed(0)}₫ — ${p.tenLoai ?? 'Không rõ loại'}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showForm(product: p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(p.id),
                          ),
                        ],
                      ),
                      children: [
                        if (p.hinhAnhs.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: p.hinhAnhs
                                .map(
                                  (url) => Image.network(
                                    "${ApiConfig.imgUrl}${url.url}",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                .toList(),
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
