import 'dart:convert';
import 'package:clean_archi_example/core/error/exceptions.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient client;

  setUp(() {
    client = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: client);
  });

  group('get concerete number trivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    final url = Uri.parse('http://numbersapi.com/$tNumber');
    final header = {'Content-Type': 'application/json'};

    test('''
        should perform a GET resquest on a URL 
        with number being the endpoint and with 
        proper header application/json
        ''', () async {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      verify(() => client.get(url, headers: header));
    });

    test(
        'it should return NumberTirvia when the response code is 200 => success',
        () async {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response('something when wrong', 404));

      final call = dataSourceImpl.getConcreteNumberTrivia;

      expect(call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get random number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    final url = Uri.parse('http://numbersapi.com/random');
    final header = {'Content-Type': 'application/json'};

    test('''
        should perform a GET resquest on a URL and with proper header application/json
        ''', () async {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      await dataSourceImpl.getRandomNumberTrivia();

      verify(() => client.get(url, headers: header));
    });

    test(
        'it should return NumberTirvia when the response code is 200 => success',
        () async {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      final result = await dataSourceImpl.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      when(() => client.get(url, headers: header))
          .thenAnswer((_) async => http.Response('something when wrong', 404));

      final call = dataSourceImpl.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
