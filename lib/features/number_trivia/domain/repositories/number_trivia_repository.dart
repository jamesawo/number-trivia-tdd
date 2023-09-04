import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}
