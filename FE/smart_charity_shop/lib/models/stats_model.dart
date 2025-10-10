class Stats {
  final int campaigns;
  final double totalDonated;
  final int donors;

  Stats({
    required this.campaigns,
    required this.totalDonated,
    required this.donors,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      campaigns: json['tongChienDich'] ?? json['campaigns'] ?? 0,
      totalDonated: (json['tongTienQuyenGop'] ?? json['totalDonated'] ?? 0)
          .toDouble(),
      donors: json['tongNguoiDung'] ?? json['donors'] ?? 0,
    );
  }
}
