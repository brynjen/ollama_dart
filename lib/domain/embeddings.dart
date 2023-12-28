class Embeddings {
  Embeddings({required this.embeddings});

  factory Embeddings.fromJson(Map<String, dynamic> json) =>
      Embeddings(embeddings: (json['embedding'] as List<dynamic>).map((e) => e as double).toList(growable: false));
  final List<double> embeddings;

  Map<String, dynamic> toJson() => {'embedding': embeddings};
}
