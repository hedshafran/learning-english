import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordsProvider with ChangeNotifier {
  List<Word> _words = [];

  List<Word> get words => _words;

  void addWord(Word word) {
    _words.add(word);
    notifyListeners();
    saveWords();
  }

  void updateWord(int index, Word word) {
    _words[index] = word;
    notifyListeners();
    saveWords();
  }

  void saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wordsJson = _words
        .map((word) => jsonEncode({
              'english': word.english,
              'hebrew': word.hebrew,
              'color': word.color,
            }))
        .toList();
    await prefs.setStringList('words', wordsJson);
  }

  void loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wordsJson = prefs.getStringList('words');
    if (wordsJson != null) {
      _words = wordsJson.map((wordJson) {
        var wordMap = jsonDecode(wordJson);
        return Word(
          english: wordMap['english'],
          hebrew: wordMap['hebrew'],
          color: wordMap['color'],
        );
      }).toList();
      notifyListeners();
    }
  }

  void deleteWord(int index) {
    _words.removeAt(index);
    notifyListeners();
    saveWords();
  }
}
