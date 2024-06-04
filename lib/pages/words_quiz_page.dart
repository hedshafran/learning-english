import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
import 'package:noam_learns_english/widgets/flipping_card.dart';
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
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
    );

    var wordsProvider = Provider.of<WordsProvider>(context);
    var words = wordsProvider.words;
    if (selectedColor != null) {
      words = selectedColor == 'all'
          ? words
          : words.where((word) => word.color == selectedColor).toList();
    }

    var currentWord = words.isNotEmpty ? words[currentIndex] : null;

    var dropdownButton = DropdownButton<String>(
      value: selectedColor,
      hint: const Text("Select a color"),
      items: <String>['all', 'green', 'yellow', 'red', 'new']
          .map((String value) {
        Color textColor;
        switch (value) {
          case 'green':
            textColor = Colors.green;
            break;
          case 'yellow':
            textColor = Colors.yellow;
            break;
          case 'red':
            textColor = Colors.red;
            break;
          case 'new':
            textColor = Colors.black;
            break;
          default:
            textColor = Colors.black;
        }
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedColor = newValue;
          currentIndex = 0;
        });
      },
    );

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
      body: SafeArea(
        child: Column(
          children: words.isEmpty || currentWord == null
              ? [
                  dropdownButton,
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No words available.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]
              : [
                  dropdownButton,
                  Expanded(
                    child: Center(
                      child: FlippingCard(currentWord: currentWord),
                    ),
                  ),
                  RatingButtons(
                      wordsProvider: wordsProvider,
                      currentIndex: currentIndex,
                      currentWord: currentWord),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            currentIndex = (currentIndex - 1) % words.length;
                          });
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          await flutterTts.speak(currentWord.english);
                        },
                        child: const Icon(Icons.music_note),
                      ),
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            currentIndex = Random().nextInt(words.length);
                          });
                        },
                        child: const Icon(Icons.shuffle),
                      ),
                      ElevatedButton(
                        style: buttonStyle,
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
