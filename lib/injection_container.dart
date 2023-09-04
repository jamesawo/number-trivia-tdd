import 'package:clean_archi_example/core/network/network_info.dart';
import 'package:clean_archi_example/core/util/input_converter.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_archi_example/features/number_trivia/data/impl_repositories/number_trivia_repository_impl.dart';
import 'package:clean_archi_example/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();

  // features - number trivia
  // block
  sl.registerFactory(
    () => NumberTriviaBloc(
      concreteNumberTriviaUseCase: sl(),
      randomNumberTriviaUseCase: sl(),
      inputConverter: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));

  // external
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Client>(() => Client());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));
}
