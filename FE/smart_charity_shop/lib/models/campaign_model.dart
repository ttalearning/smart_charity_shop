class Campaign {
  final int id;
  final String tenChienDich;
  final String? moTa;
  final String? hinhAnhChinh;
  final double mucTieu;
  final double soTienHienTai;
  final String trangThai;
  final String? diaDiem;
  final DateTime? ngayBatDau;
  final DateTime? ngayKetThuc;
  final List<String> hinhAnhPhu;

  double get progress =>
      mucTieu > 0 ? (soTienHienTai / mucTieu).clamp(0, 1) : 0;

  Campaign({
    required this.id,
    required this.tenChienDich,
    this.moTa,
    this.hinhAnhChinh,
    required this.mucTieu,
    required this.soTienHienTai,
    required this.trangThai,
    this.diaDiem,
    this.ngayBatDau,
    this.ngayKetThuc,
    required this.hinhAnhPhu,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      tenChienDich: json['tenChienDich'] ?? '',
      moTa: json['moTa'],
      hinhAnhChinh: json['hinhAnhChinh'],
      mucTieu: (json['mucTieu'] ?? 0).toDouble(),
      soTienHienTai: (json['soTienHienTai'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? 'Đang diễn ra',
      diaDiem: json['diaDiem'],
      ngayBatDau: json['ngayBatDau'] != null
          ? DateTime.tryParse(json['ngayBatDau'])
          : null,
      ngayKetThuc: json['ngayKetThuc'] != null
          ? DateTime.tryParse(json['ngayKetThuc'])
          : null,
      hinhAnhPhu:
          (json['hinhAnhPhu'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
