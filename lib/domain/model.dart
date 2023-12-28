class Model {
  Model({
    required this.name,
    required this.modifiedAt,
    required this.size,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        name: json['name'],
        modifiedAt: json['modified_at'],
        size: json['size'],
      );

  /// Name of the model, with tag included
  final String name;

  /// iso date last modified
  final String modifiedAt;

  /// Size of model in bytes
  final int size;

  Map<String, dynamic> toJson() => {
        'name': name,
        'modified_at': modifiedAt,
        'size': size,
      };
}
