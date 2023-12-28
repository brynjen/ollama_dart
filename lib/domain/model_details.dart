class ModelDetails {
  ModelDetails({
    required this.license,
    required this.modelFile,
    required this.parameters,
    required this.template,
  });

  factory ModelDetails.fromJson(Map<String, dynamic> json) => ModelDetails(
        license: json['license'],
        modelFile: json['modelfile'],
        parameters: json['parameters'],
        template: json['template'],
      );
  final String license;
  final String modelFile;
  final String parameters;
  final String template;

  Map<String, dynamic> toJson() => {
        'license': license,
        'modelfile': modelFile,
        'parameters': parameters,
        'template': template,
      };
}
