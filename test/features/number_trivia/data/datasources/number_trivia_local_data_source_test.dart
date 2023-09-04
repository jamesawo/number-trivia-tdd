import 'dart:convert';

import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from sharedPreferences when there is one in the cache',
        () async {
      when(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSourceImpl.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should call sharedPreference to Cache the data', () async {
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());

      when(() => mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, expectedJsonString))
          .thenAnswer((_) => Future.value(true));
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      verify(() => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
