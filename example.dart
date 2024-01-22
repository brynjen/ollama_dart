import 'dart:io';

import 'package:ollama_dart/ollama.dart';

/// Assumes that you have mistral model downloaded with ollama pull mistral first
Future<void> main() async {
  const prompt = 'Why is the sky blue?';
  stdout.writeln('Prompt: $prompt\n');

  const exampleModel = 'mistral:latest';

  final ollama = Ollama(host: 'http://localhost');
  try {
    // Check if mistral is downloaded
    final models = await ollama.listModels();
    // Check models.models for the model with the name exampleModel. If not found then exit program

    if (!models.models.any((model) => model.name == exampleModel)) {
      stdout.writeln('Model $exampleModel not found. Please run ollama pull $exampleModel first');
      stdout.writeln('Available models: ${models.models.map((model) => model.name).join(', ')}');
      exit(1);
    }

    final result = await ollama.generateStream(
      prompt: prompt,
      model: exampleModel,
    );
    // Stream the result, adding each chunk to a single line so it outputs as a continuous stream of words
    stdout.write('Output:');
    await for (final chunk in result) {
      if (chunk.response != null) {
        stdout.write('${chunk.response}');
      }
      if (chunk.done) {
        stdout.write('\n');
      }
    }
  } catch (e) {
    stdout.writeln('Failed to output prompt: $e');
  }
  exit(1);
}
