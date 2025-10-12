class TopDonation {
  final int nguoiDungId;
  final String tenNguoiDung;
  final String? avatarUrl;
  final double tongTien;

  TopDonation({
    required this.nguoiDungId,
    required this.tenNguoiDung,
    this.avatarUrl,
    required this.tongTien,
  });

  factory TopDonation.fromJson(Map<String, dynamic> json) {
    return TopDonation(
      nguoiDungId: json['nguoiDungId'] ?? 0,
      tenNguoiDung: json['tenNguoiDung'] ?? '',
      avatarUrl: json['avatarUrl'],
      tongTien: (json['tongTien'] as num?)?.toDouble() ?? 0,
    );
  }
}
