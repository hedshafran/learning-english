import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/words_provider.dart';

class RatingButtons extends StatelessWidget {
  const RatingButtons({
    super.key,
    required this.wordsProvider,
    required this.currentWord,
  });

  final WordsProvider wordsProvider;
  final Word currentWord;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentWord.english,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: WordColor.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(
            Icons.thumb_up_outlined,
            color: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentWord.english,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: WordColor.yellow,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(
            Icons.thumbs_up_down_outlined,
            color: Colors.white,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentWord.english,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: WordColor.red,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          child: const Icon(
            Icons.thumb_down_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
