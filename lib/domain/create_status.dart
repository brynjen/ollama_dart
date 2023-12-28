/// Status update received from ollama during creation of new model
class CreateStatus {
  CreateStatus({
    this.status,
    this.error,
    this.digest,
    this.total,
    this.completed,
  });

  factory CreateStatus.fromJson(Map<String, dynamic> json) {
    return CreateStatus(
      status: json['status'],
      error: json['error'],
      digest: json['digest'],
      total: json['total'],
      completed: json['completed'],
    );
  }

  /// Current status, updated while creating in process
  final String? status;
  final String? error;
  final String? digest;
  final int? total;
  final int? completed;

  /// Model is successfully created and can be used
  bool get isSuccess => status == 'success';

  /// Have not checked what fail status is yet so need to confirm..
  bool get didFail => error != null;

  Map<String, dynamic> toJson() => {
        'status': status,
        'error': error,
        'digest': digest,
        'total': total,
        'completed': completed,
      };
}
