import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
import 'package:noam_learns_english/widgets/flipping_card.dart';
import 'package:noam_learns_english/widgets/rating_buttons.dart';
import 'package:noam_learns_english/widgets/scale_transition_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordsQuizPage extends StatelessWidget {
  const WordsQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterTts flutterTts = FlutterTts();

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

    Color backgroundColor;
    switch (wordsProvider.selectedColor) {
      case WordColor.green:
        backgroundColor = Colors.green.shade100;
        break;
      case WordColor.yellow:
        backgroundColor = Colors.yellow.shade100;
        break;
      case WordColor.red:
        backgroundColor = Colors.red.shade100;
        break;
      case WordColor.newWord:
        backgroundColor = Colors.grey.shade300;
        break;
      case WordColor.all:
        backgroundColor = Colors.grey.shade100;
        break;
    }

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: backgroundColor,
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
                        ScaleTransitionButton(
                          onPressed: () {
                            wordsProvider.previousWord();
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        ScaleTransitionButton(
                          onPressed: () async {
                            await flutterTts.speak(currentWord.english);
                          },
                          child: const Icon(Icons.music_note),
                        ),
                        ScaleTransitionButton(
                          onPressed: () {
                            wordsProvider.nextWord();
                          },
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
          ),
        ),
      ),
    );
  }
}
