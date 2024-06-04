import 'package:flutter/material.dart';
import 'package:noam_learns_english/pages/words_bank_page.dart';
import 'package:noam_learns_english/pages/words_quiz_page.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordsProvider()..loadWords(),
      child: MaterialApp(
        title: 'Noam Learns English',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const WordsQuizPage(),
        routes: {
          '/words': (context) => const WordsBankPage(),
        },
      ),
    );
  }
}
