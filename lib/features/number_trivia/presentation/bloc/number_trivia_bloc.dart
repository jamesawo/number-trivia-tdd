import 'package:clean_archi_example/core/error/failures.dart';
import 'package:clean_archi_example/core/usecase/usecase.dart';
import 'package:clean_archi_example/core/util/input_converter.dart';
import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_archi_example/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_MESSAGE = 'Invalid Input: The number must be an integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase concreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase randomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concreteNumberTriviaUseCase,
    required this.randomNumberTriviaUseCase,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumberEvent>((event, emit) async {
      return await _handleGetTriviaForConcreteNumber(event, emit);
    });
    on<GetTriviaForRandomNumberEvent>((event, emit) async => _handleGetTriviaForRandomNumber(event, emit));
  }

  NumberTriviaState get initialState => Empty();

  Future<void> _handleGetTriviaForRandomNumber(
    GetTriviaForRandomNumberEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Empty());
    emit(Loading());
    final failureOrTrivia = await randomNumberTriviaUseCase(NoParams());

    failureOrTrivia.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))), (trivia) => emit(Loaded(trivia: trivia)));
  }

  Future<void> _handleGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumberEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Empty());
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold((l) async {
      emit(const Error(message: INVALID_INPUT_MESSAGE));
    }, (integer) async {
      emit(Loading());

      final failureOrTrivia = await concreteNumberTriviaUseCase(Params(number: integer));

      emit(Loading());

      emit.isDone;
      failureOrTrivia.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (trivia) => emit(Loaded(trivia: trivia)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'UNEXPECTED ERROR';
    }
  }
}
