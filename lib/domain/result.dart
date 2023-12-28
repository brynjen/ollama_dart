class Result {
  Result({
    required this.response,
    required this.createdAt,
    required this.totalDuration,
    required this.loadDuration,
    required this.done,
    required this.sampleCount,
    required this.sampleDuration,
    required this.promptEvalCount,
    required this.promptEvalDuration,
    required this.evalCount,
    required this.evalDuration,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        response: json['response'],
        createdAt: json['created_at'],
        totalDuration: json['total_duration'],
        loadDuration: json['load_duration'],
        done: json['done'],
        sampleCount: json['sample_count'],
        sampleDuration: json['sample_duration'],
        promptEvalCount: json['prompt_eval_count'],
        promptEvalDuration: json['prompt_eval_duration'],
        evalCount: json['eval_count'],
        evalDuration: json['eval_duration'],
      );

  final String createdAt;
  final String response;
  final int? totalDuration;
  final int? loadDuration;
  final bool done;
  final int? sampleCount;
  final int? sampleDuration;
  final int? promptEvalCount;
  final int? promptEvalDuration;
  final int? evalCount;
  final int? evalDuration;

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'response': response,
        'total_duration': totalDuration,
        'load_duration': loadDuration,
        'done': done,
        'sample_count': sampleCount,
        'sample_duration': sampleDuration,
        'prompt_eval_count': promptEvalCount,
        'prompt_eval_duration': promptEvalDuration,
        'eval_count': evalCount,
        'eval_duration': evalDuration,
      };
}
