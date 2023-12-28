/// Returns a chunk of the response from ollama. This will come in a stream from
/// the POST result so ensure it works
class Chunk {
  Chunk({
    required this.model,
    required this.createdAt,
    required this.response,
    required this.done,
    this.context,
    this.totalDuration,
    this.loadDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
  });

  /// Model used by ollama
  final String model;
  final String? createdAt;

  /// Segmented part of the response
  final String? response;

  /// If the response is the final response
  final bool done;

  final List<int>? context;

  /// All durations are in nanoseconds
  final double? totalDuration;

  /// Time spent loading into memory? Check ollama
  final double? loadDuration;

  /// What is this?
  final int? promptEvalCount;

  final double? promptEvalDuration;

  /// Tokens in evaluation? Check ollama
  final int? evalCount;

  final double? evalDuration;

  factory Chunk.fromJson(Map<String, dynamic> json) => Chunk(
        model: json['model'],
        createdAt: json['created_at'],
        response: json['response'],
        done: json['done'] ?? false,
        context: json['context'] != null ? List<int>.from(json['context']) : null,
        totalDuration: json['total_duration']?.toDouble(),
        loadDuration: json['load_duration']?.toDouble(),
        promptEvalCount: json['prompt_eval_count'],
        promptEvalDuration: json['prompt_eval_duration']?.toDouble(),
        evalCount: json['eval_count'],
        evalDuration: json['eval_duration']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'model': model,
        'created_at': createdAt,
        'response': response,
        'done': done,
        'total_duration': totalDuration,
        'load_duration': loadDuration,
        'prompt_eval_count': promptEvalCount,
        'prompt_eval_duration': promptEvalDuration,
        'eval_count': evalCount,
        'eval_duration': evalDuration,
      };
}
