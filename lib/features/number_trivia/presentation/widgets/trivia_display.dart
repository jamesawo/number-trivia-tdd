import 'package:clean_archi_example/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTriviaEntity numberTriviaEntity;

  const TriviaDisplay({required this.numberTriviaEntity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${numberTriviaEntity.number}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(numberTriviaEntity.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
