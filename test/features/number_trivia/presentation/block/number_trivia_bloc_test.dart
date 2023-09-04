import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/core/usecase/usecase.dart';
import 'package:clean_archi_example/core/util/input_converter.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTrivia extends Mock
    implements GetRandomNumberTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc mockBlock;
  late MockGetConcreteNumberTrivia concreteNumberTriviaUsecase;
  late MockGetRandomNumberTrivia randomNumberTriviaUsecase;
  late MockInputConverter inputConverter;

  setUp(() {
    concreteNumberTriviaUsecase = MockGetConcreteNumberTrivia();
    randomNumberTriviaUsecase = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    mockBlock = NumberTriviaBloc(
      concreteNumberTriviaUseCase: concreteNumberTriviaUsecase,
      randomNumberTriviaUseCase: randomNumberTriviaUsecase,
      inputConverter: inputConverter,
    );
  });

  test('should set inital state to Empty', () {
    expect(mockBlock.initialState, Empty());
  });

  group('get trivia for concrete number', () {
    const tNumberString = '1';
    const tNumberStringInvalid = 'abc';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTriviaEntity(text: 'Text', number: 1);
    const params = Params(number: tNumberParsed);

    void stubInputConverterAndConcreteNumberTriviaUseCase() {
      when(() => inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(const Right(tNumberParsed));

      when(() => concreteNumberTriviaUsecase(params))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    test(
        'should call the input converter to convert the string to unsigned integer',
        () async {
      stubInputConverterAndConcreteNumberTriviaUseCase();

      mockBlock.add(const GetTriviaForConcreteNumberEvent(tNumberString));

      await untilCalled(
          () => inputConverter.stringToUnsignedInteger(tNumberString));

      verify(() => inputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should return [Error] state when input is invalid', () async {
      when(() => inputConverter.stringToUnsignedInteger(tNumberStringInvalid))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Empty(), const Error(message: INVALID_INPUT_MESSAGE)];
      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock
          .add(const GetTriviaForConcreteNumberEvent(tNumberStringInvalid));
    });

    test('should get data from the concrete usecase', () async {
      stubInputConverterAndConcreteNumberTriviaUseCase();

      mockBlock.add(const GetTriviaForConcreteNumberEvent(tNumberString));

      await untilCalled(() => concreteNumberTriviaUsecase(params));

      verify(() => concreteNumberTriviaUsecase(params));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      stubInputConverterAndConcreteNumberTriviaUseCase();

      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] when data fails', () {
      //stubInputConverterAndConcreteNumberTriviaUseCase();
      when(() => inputConverter.stringToUnsignedInteger(tNumberString))
          .thenReturn(const Right(tNumberParsed));

      when(() => concreteNumberTriviaUsecase(params))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () {
      stubInputConverterAndConcreteNumberTriviaUseCase();

      when(() => concreteNumberTriviaUsecase(params))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(const GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('get trivia for random number', () {
    const tNumberTrivia = NumberTriviaEntity(text: 'Text', number: 1);
    final noParams = NoParams();

    test('should get data from the random usecase', () async {
      when(() => randomNumberTriviaUsecase(noParams))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      mockBlock.add(GetTriviaForRandomNumberEvent());

      await untilCalled(() => randomNumberTriviaUsecase(noParams));

      verify(() => randomNumberTriviaUsecase(noParams));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      when(() => randomNumberTriviaUsecase(noParams))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      final expected = [
        Empty(),
        Loading(),
        const Loaded(trivia: tNumberTrivia)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] when data fails', () {
      when(() => randomNumberTriviaUsecase(noParams))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(GetTriviaForRandomNumberEvent());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () {
      when(() => randomNumberTriviaUsecase(noParams))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(mockBlock.stream, emitsInOrder(expected));

      mockBlock.add(GetTriviaForRandomNumberEvent());
    });
  });
}
