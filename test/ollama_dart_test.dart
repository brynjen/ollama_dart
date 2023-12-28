import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ollama_dart/ollama.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  group('Ollama', () {
    late Ollama ollama;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      ollama = Ollama(host: 'fakeHost', client: mockClient);
    });

    test('Test generate stream returns successful stream', () async {
      // Arrange
      const expectedResponse = 'Test response';
      // Mockito handles non-null poorly, needding special treatment. Check out https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
      //when(mockClient.send(any)).thenAnswer((_) async => http.StreamedResponse(Stream.fromIterable([expectedResponse.codeUnits]), 200));

      // Act
      final stream = await ollama.generateStream(prompt: 'Gibberish', model: 'Mixtral');

      // Assert
      expect(await stream.first, expectedResponse);
    });
  });
}
