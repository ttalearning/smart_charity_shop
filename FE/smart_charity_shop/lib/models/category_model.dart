class Category {
  final int id;
  final String tenLoai;
  final bool isActive;
  final int soSanPham;

  Category({
    required this.id,
    required this.tenLoai,
    required this.isActive,
    required this.soSanPham,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      tenLoai: json['tenLoai'] ?? '',
      isActive: json['isActive'] ?? true,
      soSanPham: json['soSanPham'] ?? 0,
    );
  }
}
