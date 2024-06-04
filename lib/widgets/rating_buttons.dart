import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/words_provider.dart';

class RatingButtons extends StatelessWidget {
  const RatingButtons({
    super.key,
    required this.wordsProvider,
    required this.currentIndex,
    required this.currentWord,
  });

  final WordsProvider wordsProvider;
  final int currentIndex;
  final Word currentWord;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentIndex,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: 'green',
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Icon(
            Icons.thumb_up_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentIndex,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: 'yellow',
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: const Icon(
            Icons.thumbs_up_down_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            wordsProvider.updateWord(
              currentIndex,
              Word(
                english: currentWord.english,
                hebrew: currentWord.hebrew,
                color: 'red',
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
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