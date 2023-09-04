import 'package:clean_archi_example/core/error/exceptions.dart';
import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_archi_example/core/network/network_info.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
    int number,
  ) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
      _ConcreteOrRandomChooser chooser) async {
    if (await networkInfo.isConnected) {
      return _getTriviaFromRemoteDataSource(chooser);
    } else {
      return await _getTriviaFromLocalDataSource();
    }
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTriviaFromRemoteDataSource(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    try {
      NumberTriviaModel triviaModel = await getConcreteOrRandom();
      localDataSource.cacheNumberTrivia(triviaModel);
      return Right(triviaModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, NumberTriviaEntity>>
      _getTriviaFromLocalDataSource() async {
    try {
      var numberTriviaModel = await localDataSource.getLastNumberTrivia();
      return Right(numberTriviaModel);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
