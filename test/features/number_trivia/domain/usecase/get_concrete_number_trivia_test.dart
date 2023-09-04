import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTriviaUseCase usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  });

  test('should get trivia for the number from the repository', () async {
    const tNumber = 1;
    const tNumberTrivia = NumberTriviaEntity(text: 'text', number: tNumber);

    // arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => const Right(tNumberTrivia));
    // act ->
    var result = await usecase(const Params(number: tNumber));
    // assert
    expect(result, const Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
