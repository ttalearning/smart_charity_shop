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
  final List<String> hinhAnhs;

  double get progress =>
      mucTieu > 0 ? (soTienHienTai / mucTieu).clamp(0.0, 1.0) : 0.0;

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
    required this.hinhAnhs,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as int,
      tenChienDich: json['tenChienDich'] ?? '',
      moTa: json['moTa'],
      hinhAnhChinh: json['hinhAnhChinh'],
      mucTieu: (json['mucTieu'] as num?)?.toDouble() ?? 0,
      soTienHienTai: (json['soTienHienTai'] as num?)?.toDouble() ?? 0,
      trangThai: json['trangThai'] ?? 'Đang diễn ra',
      diaDiem: json['diaDiem'],
      ngayBatDau: json['ngayBatDau'] != null
          ? DateTime.parse(json['ngayBatDau'])
          : null,
      ngayKetThuc: json['ngayKetThuc'] != null
          ? DateTime.parse(json['ngayKetThuc'])
          : null,
      hinhAnhs:
          (json['hinhAnhs'] as List<dynamic>?)
              ?.map((e) => e['url'] as String)
              .toList() ??
          [],
    );
  }
}
