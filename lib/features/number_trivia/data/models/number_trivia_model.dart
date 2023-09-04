import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  const NumberTriviaModel({
    required number,
    required text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) {
    return NumberTriviaModel(
      text: jsonMap['text'],
      number: (jsonMap['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'text': text};
  }
}
