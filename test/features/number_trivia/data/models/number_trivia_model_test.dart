import 'dart:convert';

import 'package:clean_archi_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaModel numberTriviaModel;
  setUp(() {
    numberTriviaModel = const NumberTriviaModel(number: 1, text: 'Test Text');
  });

  test('it should be an instance of NumberTriviaEntity', () {
    expect(numberTriviaModel, isA<NumberTriviaEntity>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, numberTriviaModel);
    });

    test('should return a valid model when the JSON number is regarded as a double', () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, numberTriviaModel);
    });

    test('should return a JSON map containing the proper data', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {'text': numberTriviaModel.text, 'number': numberTriviaModel.number};
      // act
      final result = numberTriviaModel.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
