import 'dart:io';

import 'package:ollama_dart/ollama.dart';

/// Assumes that you have mistral model downloaded with ollama pull mistral first
Future<void> main() async {
  final ollama = Ollama(host: 'http://localhost');
  try {
    final result = await ollama.generateResult(
      prompt: 'Why is the sky blue?',
      model: 'mistral',
    );
    stdout.writeln('Final result: ${result.response}');
  } catch (e) {
    stdout.writeln('Failed: $e');
  }
  exit(0);
}
