import 'package:ollama_dart/domain/model.dart';

class Models {
  Models({required this.models});

  final List<Model> models;

  factory Models.fromJson(Map<String, dynamic> json) => Models(
        models: (json['models'] as List<dynamic>).map((modelJson) => Model.fromJson(modelJson)).toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'models': models.map((model) => model.toJson()).toList(growable: false),
      };
}
