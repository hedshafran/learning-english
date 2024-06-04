import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
import 'package:noam_learns_english/widgets/rating_buttons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordsQuizPage extends StatefulWidget {
  const WordsQuizPage({super.key});

  @override
  State<WordsQuizPage> createState() => _WordsQuizPageState();
}

class _WordsQuizPageState extends State<WordsQuizPage> {
  FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground);
    var wordsProvider = Provider.of<WordsProvider>(context);
    var words = wordsProvider.words;

    var currentWord = words.isNotEmpty ? words[currentIndex] : null;

    return Scaffold(
      // add a button to the app bar that takes to the words bank page
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Words Quiz',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.list,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              Navigator.pushNamed(context, '/words');
            },
          ),
        ],
      ),
      body: words.isEmpty || currentWord == null
          ? const Center(
              child: Text(
              'No words available.',
              textAlign: TextAlign.center,
            ))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Card(
                          elevation: 30,
                          color: currentWord.color == 'green'
                              ? Colors.green.shade100
                              : currentWord.color == 'yellow'
                                  ? Colors.yellow.shade100
                                  : Colors.red.shade100,
                          child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: Text(currentWord.english,
                                  style: textStyle,
                                  textAlign: TextAlign.center))),
                    ),
                  ),
                  RatingButtons(wordsProvider: wordsProvider, currentIndex: currentIndex, currentWord: currentWord),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = (currentIndex - 1) % words.length;
                          });
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await flutterTts.speak(currentWord.english);
                        },
                        child: const Icon(Icons.music_note),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = Random().nextInt(words.length);
                          });
                        },
                        child: const Icon(Icons.shuffle),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(currentWord.hebrew,
                                  style: textStyle,
                                  textAlign: TextAlign.center),
                            ),
                          );
                        },
                        child: const Icon(Icons.question_mark),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = (currentIndex + 1) % words.length;
                          });
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
