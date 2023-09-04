import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/core/usecase/usecase.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTriviaUseCase implements UseCase<NumberTriviaEntity, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
