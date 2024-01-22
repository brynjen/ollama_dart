library ollama_dart;

import 'dart:convert';
import 'dart:io';
import 'package:ollama_dart/domain/chunk.dart';
import 'package:http/http.dart' as http;
import 'package:ollama_dart/domain/create_status.dart';
import 'package:ollama_dart/domain/download.dart';
import 'package:ollama_dart/domain/embeddings.dart';
import 'package:ollama_dart/domain/model_details.dart';
import 'package:ollama_dart/domain/models.dart';
import 'package:ollama_dart/domain/result.dart';

class Ollama {
  Ollama({required this.host, this.port = 11434, http.Client? client}) : client = client ?? http.Client();
  final String host;
  final int port;
  http.Client client;

  /// Generates a stream of chunks as an answer to a question. Note that the
  /// model itself contains the system prompt
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#generate-a-completion
  Future<Stream<Chunk>> generateStream({
    required String prompt,
    required String model,
    String? systemPrompt,
    List<int>? context,
  }) async {
    final urlString = '$host:$port/api/generate';
    final request = http.Request('POST', Uri.parse(urlString));
    request.body = json.encode({
      'prompt': prompt,
      'model': model,
      'context': context,
    });
    request.headers['Content-Type'] = 'application/json';
    final result = await client.send(request);
    return result.stream.transform(utf8.decoder).map((text) => json.decode(text)).map(
          (jsonObject) => Chunk.fromJson(jsonObject),
        );
  }

  Future<Result> generateResult({
    required String prompt,
    required String model,
    String? template,
    String? systemPrompt,
    Map<String, dynamic>? options,
    List<int>? context,
  }) async {
    final urlString = '$host:$port/api/generate';
    final params = {
      'prompt': prompt,
      'model': model,
      'stream': false,
    };
    if (template != null) {
      params['template'] = template;
    }
    if (systemPrompt != null) {
      params['system'] = systemPrompt;
    }
    if (options != null) {
      params['options'] = options;
    }
    if (context != null) {
      params['context'] = context;
    }
    final body = json.encode(params);
    final result = await client.post(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return Result.fromJson(jsonDecode(result.body));
  }

  /// Creates a new model for local ollama service
  /// Requires full name of model as well as path to Modelfile
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#create-a-model
  Future<Stream<CreateStatus>> create(String name, String path) async {
    final urlString = '$host:$port/api/create';
    final request = http.Request('POST', Uri.parse(urlString));
    try {
      request.body = json.encode({'name': name, 'path': path});
      request.headers['Content-Type'] = 'application/json';
      final result = await client.send(request);
      return result.stream.transform(utf8.decoder).map((text) => json.decode(text)).map(
        (jsonObject) {
          return CreateStatus.fromJson(jsonObject);
        },
      );
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to connect to the server: $e');
    }
  }

  /// Returns a list of available models
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#list-local-models
  Future<Models> listModels() async {
    final urlString = '$host:$port/api/tags';
    try {
      final response = await http.get(
        Uri.parse(urlString),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Models.fromJson(json.decode(response.body));
      } else {
        throw Exception('Shit gone wrong: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to connect to the server: $e');
    }
  }

  /// Returns details about given model
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#show-model-information
  Future<ModelDetails> showModel(String name) async {
    final urlString = '$host:$port/api/show';
    final response = await client.post(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body).map(
            (jsonObject) => ModelDetails.fromJson(jsonObject),
          );
    } else {
      throw Exception('Shit gone wrong: ${response.statusCode}');
    }
  }

  /// Both source and destination needs to be full names with base and tag
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#copy-a-model
  Future<void> copyModel(String source, String destination) async {
    final urlString = '$host:$port/api/copy';
    final response = await client.post(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'source': source, 'destination': destination}),
    );
    if (response.statusCode != 200) {
      throw Exception('Copy failed: ${response.statusCode}: ${response.body}');
    }
  }

  /// name of model must be full name with base and tag
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#delete-a-model
  Future<void> deleteModel(String name) async {
    final urlString = '$host:$port/api/delete';
    final response = await client.delete(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.statusCode}: ${response.body}');
    }
  }

  /// Pulls a new model from remote ollama library. Should only be used when
  /// setting up system or sparingly if you need to. Do a manual download if you
  /// need to not automate it
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#pull-a-model
  Future<Download> downloadModel(String name, {bool allowInsecure = false}) async {
    final urlString = '$host:$port/api/pull';
    final response = await client.post(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body).map(
            (jsonObject) => Download.fromJson(jsonObject),
          );
    } else {
      throw Exception('Shit gone wrong: ${response.statusCode}');
    }
  }

  /// [name] : name of model to generate embeddings from
  /// [prompt] : text to generate embeddings for
  /// [options] : additional model parameters listed in the documentation for the
  /// Modelfile such as temperature
  /// https://github.com/jmorganca/ollama/blob/main/docs/api.md#generate-embeddings
  Future<Embeddings> generateEmbeddings(String model, String prompt, {String? options}) async {
    final urlString = '$host:$port/api/embeddings';
    final payload = {'model': model, 'prompt': prompt};
    if (options != null) {
      payload['options'] = options;
    }
    final response = await client.post(
      Uri.parse(urlString),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      return Embeddings.fromJson(json.decode(response.body));
    } else {
      throw Exception('Shit gone wrong: ${response.statusCode}');
    }
  }
}
