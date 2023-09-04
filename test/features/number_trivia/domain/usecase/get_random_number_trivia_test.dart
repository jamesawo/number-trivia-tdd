import 'package:clean_archi_example/core/usecase/usecase.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'get_concrete_number_trivia_test.dart';

void main() {
  late NumberTriviaRepository mockRepository;
  late GetRandomNumberTriviaUseCase useCase;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTriviaUseCase(mockRepository);
  });

  const tNumberTrivia = NumberTriviaEntity(text: 'text', number: 2);
  test('should get trivia from repository', () async {
    // arrange
    when(() => mockRepository.getRandomNumberTrivia()).thenAnswer((_) async => const Right(tNumberTrivia));
    // act
    final result = await useCase(NoParams());
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRepository);
  });
}
