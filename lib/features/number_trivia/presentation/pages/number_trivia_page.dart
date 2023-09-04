import 'package:clean_archi_example/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_archi_example/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/trivia_controls.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(message: 'Start Searching!');
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTriviaEntity: state.trivia);
                } else if (state is Loading) {
                  return const LoadingWidget();
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Placeholder(),
                );
              }),
              const SizedBox(height: 20),
              // bottom half
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
