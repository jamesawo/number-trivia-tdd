import 'package:clean_archi_example/core/error/exceptions.dart';
import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/core/network/network_info.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/impl_repositories/number_trivia_repository_impl.dart';
import 'package:clean_archi_example/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('when device is online', () {
      setUp(() => when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true));
      body();
    });
  }

  void runTestOffline(Function body) {
    group('when device is offline', () {
      setUp(() => when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false));

      body();
    });
  }

  group('getConcreteNumberTrivia in NumberTriviaRepositoryImpl', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    const tNumberTriviaEntity = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => tNumberTriviaModel);

      // act
      await repositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTriviaModel)));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test('should return CacheFailure when they is no cached data is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia in NumberTriviaRepositoryImpl', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    const tNumberTriviaEntity = tNumberTriviaModel;

    // test('should check if the device is online', () {
    //   // arrange
    //   when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
    //   // act
    //   repositoryImpl.getRandomNumberTrivia();
    //   // assert
    //   verify(() => mockNetworkInfo.isConnected);
    // });

    runTestOnline(() {
      // test('should return remote data when the call to remote data source is successful', () async {
      //   // arrange
      //   when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
      //   // act
      //   final result = await repositoryImpl.getRandomNumberTrivia();
      //   // assert
      //   verify(() => mockRemoteDataSource.getRandomNumberTrivia());
      //   expect(result, equals(const Right(tNumberTriviaModel)));
      // });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        // act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      test('should return last locally cached data when the cached data is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaEntity)));
      });

      test('should return CacheFailure when they is no cached data is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        // act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
