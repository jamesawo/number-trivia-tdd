import 'package:clean_archi_example/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';

// import 'injection_container.dart' as di;
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Colors.green.shade800),
      home: const NumberTriviaPage(),
    );
  }
}
