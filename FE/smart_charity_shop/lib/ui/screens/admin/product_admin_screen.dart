import 'package:flutter/material.dart';
import '../../../services/product_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class ProductAdminScreen extends StatefulWidget {
  const ProductAdminScreen({super.key});

  @override
  State<ProductAdminScreen> createState() => _ProductAdminScreenState();
}

class _ProductAdminScreenState extends State<ProductAdminScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final data = await ProductService.fetchAll();
    setState(() {
      _products = data;
      _loading = false;
    });
  }

  Future<void> _deleteProduct(int id) async {
    final success = await ProductService.delete(id);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xóa sản phẩm.")));
      _loadProducts();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Xóa thất bại.")));
    }
  }

  void _showForm({Map<String, dynamic>? product}) {
    final nameCtrl = TextEditingController(text: product?["tenSanPham"]);
    final priceCtrl = TextEditingController(
      text: product?["gia"]?.toString() ?? "",
    );
    final descCtrl = TextEditingController(text: product?["moTa"]);
    final imageCtrl = TextEditingController(text: product?["anhChinh"]);
    final loaiIdCtrl = TextEditingController(
      text: product?["loaiId"]?.toString() ?? "1",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Thêm sản phẩm" : "Chỉnh sửa sản phẩm"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Tên sản phẩm"),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: "Giá"),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Mô tả"),
              ),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: "Ảnh chính (URL)"),
              ),
              TextField(
                controller: loaiIdCtrl,
                decoration: const InputDecoration(labelText: "Loại ID"),
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
              final productData = {
                "tenSanPham": nameCtrl.text,
                "gia": double.tryParse(priceCtrl.text) ?? 0,
                "moTa": descCtrl.text,
                "anhChinh": imageCtrl.text,
                "loaiId": int.tryParse(loaiIdCtrl.text) ?? 1,
              };

              bool success;
              if (product == null) {
                success = await ProductService.create(productData);
              } else {
                success = await ProductService.update(
                  product["id"],
                  productData,
                );
              }

              if (success && mounted) {
                Navigator.pop(context);
                _loadProducts();
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
              onRefresh: _loadProducts,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _products.length,
                itemBuilder: (_, i) {
                  final p = _products[i];
                  return Card(
                    child: ListTile(
                      leading: p["anhChinh"] != null
                          ? Image.network(
                              p["anhChinh"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported, size: 40),
                      title: Text(p["tenSanPham"]),
                      subtitle: Text("${p["gia"]}₫"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showForm(product: p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(p["id"]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
