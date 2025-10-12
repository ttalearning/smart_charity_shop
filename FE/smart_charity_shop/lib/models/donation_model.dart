class Donation {
  final int id;
  final int nguoiDungId;
  final String tenNguoiDung;
  final int chienDichId;
  final String tenChienDich;
  final double soTien;

  final String loaiNguon;
  final DateTime ngayTao;

  Donation({
    required this.id,
    required this.nguoiDungId,
    required this.tenNguoiDung,
    required this.chienDichId,
    required this.tenChienDich,
    required this.soTien,
    required this.loaiNguon,
    required this.ngayTao,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'] ?? 0,
      nguoiDungId: json['nguoiDungId'] ?? 0,
      tenNguoiDung: json['tenNguoiDung'] ?? '',
      chienDichId: json['chienDichId'] ?? 0,
      tenChienDich: json['tenChienDich'] ?? '',
      soTien: (json['soTien'] as num?)?.toDouble() ?? 0,
      loaiNguon: json['loaiNguon'] ?? '',
      ngayTao: DateTime.tryParse(json['ngayTao'] ?? '') ?? DateTime.now(),
    );
  }
}
