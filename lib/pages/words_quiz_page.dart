import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
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

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(10),
    );

    var wordsProvider = Provider.of<WordsProvider>(context);
    Word? currentWord = wordsProvider.currentWord;
    var words = wordsProvider.filteredWords;

    var dropdownButton = DropdownButton<String>(
      value: wordsProvider.selectedColor.value,
      hint: const Text("Select a color"),
      items: WordColor.values
          .map((color) => DropdownMenuItem(
                value: color.value,
                child: Text(color.name,
                    style: TextStyle(
                        color: color == WordColor.green
                            ? Colors.green
                            : color == WordColor.yellow
                                ? Colors.yellow
                                : color == WordColor.red
                                    ? Colors.red
                                    : Colors.black)),
              ))
          .toList(),
      onChanged: (newValue) {
        wordsProvider.selectedColor = WordColor.values.firstWhere(
            (color) => color.value == newValue,
            orElse: () => WordColor.all);
      },
    );

    return Scaffold(
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
                      wordsProvider: wordsProvider, currentWord: currentWord),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            wordsProvider.previousWord();
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
                            wordsProvider.randomizeWords();
                          });
                        },
                        child: const Icon(Icons.shuffle),
                      ),
                      ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            wordsProvider.nextWord();
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
