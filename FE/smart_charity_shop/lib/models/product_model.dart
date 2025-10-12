class Product {
  final int id;
  final String tenSanPham;
  final double gia;
  final String? moTa;
  final String? anhChinh;
  final int loaiId;
  final String? tenLoai;

  Product({
    required this.id,
    required this.tenSanPham,
    required this.gia,
    this.moTa,
    this.anhChinh,
    required this.loaiId,
    this.tenLoai,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      tenSanPham: json['tenSanPham'] ?? '',
      gia: (json['gia'] ?? 0).toDouble(),
      moTa: json['moTa'],
      anhChinh: json['anhChinh'],
      loaiId: json['loaiId'] ?? 0,
      tenLoai: json['tenLoai'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenSanPham': tenSanPham,
      'gia': gia,
      'moTa': moTa,
      'anhChinh': anhChinh,
      'loaiId': loaiId,
      'tenLoai': tenLoai,
    };
  }
}
