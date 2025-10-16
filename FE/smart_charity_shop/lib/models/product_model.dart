class Product {
  final int id;
  final String tenSanPham;
  final double gia;
  final String? moTa;
  final String? anhChinh;
  final int loaiId;
  final String? tenLoai;
  final List<ProductImage> hinhAnhs; // <== sửa kiểu

  Product({
    required this.id,
    required this.tenSanPham,
    required this.gia,
    this.moTa,
    this.anhChinh,
    required this.loaiId,
    this.tenLoai,
    this.hinhAnhs = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesJson = json['hinhAnhs'] ?? [];

    return Product(
      id: json['id'] ?? 0,
      tenSanPham: json['tenSanPham'] ?? '',
      gia: (json['gia'] ?? 0).toDouble(),
      moTa: json['moTa'],
      anhChinh: json['anhChinh'],
      loaiId: json['loaiId'] ?? 0,
      tenLoai: json['tenLoai'],
      hinhAnhs: imagesJson.map((e) => ProductImage.fromJson(e)).toList(),
    );
  }
}

class ProductImage {
  final int id;
  final String url;
  final int sanPhamId;
  final bool isChinh;

  ProductImage({
    required this.id,
    required this.url,
    required this.sanPhamId,
    required this.isChinh,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      sanPhamId: json['sanPhamId'] ?? 0,
      isChinh: json['isChinh'] ?? false,
    );
  }
}
