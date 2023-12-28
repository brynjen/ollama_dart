class Download {
  Download({
    required this.status,
    required this.digest,
    required this.total,
  });

  factory Download.fromJson(Map<String, dynamic> json) => Download(
        status: json['status'],
        digest: json['digest'],
        total: json['total'],
      );

  final String status;
  final String digest;
  final double total;

  Map<String, dynamic> toJson() => {
        'status': status,
        'digest': digest,
        'total': total,
      };
}
