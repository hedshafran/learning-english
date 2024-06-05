import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/default_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordsProvider with ChangeNotifier {
  Word? _currentWord;

  Word? get currentWord => _currentWord;

  set currentWord(Word? word) {
    _currentWord = word;
    notifyListeners();
  }

  WordColor _selectedColor = WordColor.all;

  WordColor get selectedColor => _selectedColor;

  set selectedColor(WordColor color) {
    _selectedColor = color;
    switch (color) {
      case WordColor.green:
        _filteredWords = _words.where((word) => word.color == WordColor.green).toList();
        break;
      case WordColor.yellow:
        _filteredWords = _words.where((word) => word.color == WordColor.yellow).toList();
        break;
      case WordColor.red:
        _filteredWords = _words.where((word) => word.color == WordColor.red).toList();
        break;
      case WordColor.newWord:
        _filteredWords = _words.where((word) => word.color == WordColor.newWord).toList();
        break;
      case WordColor.all:
        _filteredWords = _words;
        break;
    }
    _currentWord = _filteredWords.isNotEmpty ? _filteredWords[0] : _currentWord;
    notifyListeners();
  }

  List<Word> _words = [];

  List<Word> get words => _words;

  List<Word> _filteredWords = [];

  List<Word> get filteredWords => _filteredWords;

  void nextWord() {
    int index = _filteredWords.indexWhere((word) => word.english == _currentWord!.english);
    if (index == _filteredWords.length - 1) {
      _currentWord = _filteredWords[0];
    } else {
      _currentWord = _filteredWords[index + 1];
    }
    notifyListeners();
  }

  void previousWord() {
    int index = _filteredWords.indexWhere((word) => word.english == _currentWord!.english);
    if (index == 0) {
      _currentWord = _filteredWords[_filteredWords.length - 1];
    } else {
      _currentWord = _filteredWords[index - 1];
    }
    notifyListeners();
  }

  void addWord(Word word) {
    _words.add(word);
    notifyListeners();
    saveWords();
  }

  void updateWord(String englishValue, Word word) {
    int index = _words.indexWhere((element) => element.english == englishValue);
    _words[index] = word;
    int filteredIndex = _filteredWords.indexWhere((element) => element.english == englishValue);
    if (filteredIndex != -1) {
      _filteredWords[filteredIndex] = word;
    }
    if (_currentWord!.english == englishValue) {
      _currentWord = word;
    }
    notifyListeners();
    saveWords();
  }

  void saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wordsJson = _words
        .map((word) => jsonEncode({
              'english': word.english,
              'hebrew': word.hebrew,
              'color': word.color.name,
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
          color: WordColor.values.firstWhere((color) => color.name == wordMap['color']),
        );
      }).toList();
      _filteredWords = _words;
      _currentWord = _filteredWords[0];
      notifyListeners();
    }

    if (_words.isEmpty) {
      _words = defaultWords;
      saveWords();
    }
  }

  void deleteWord(int index) {
    _words.removeAt(index);
    notifyListeners();
    saveWords();
  }

  void randomizeWords() {
    _words.shuffle();
    notifyListeners();
  }
}
