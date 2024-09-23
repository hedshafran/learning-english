import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/default_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WordsProvider with ChangeNotifier {
  Word? _currentWord;
  WordColor _selectedColor = WordColor.all;
  List<Word> _words = [];
  List<Word> _filteredWords = [];

  Word? get currentWord => _currentWord;
  WordColor get selectedColor => _selectedColor;
  List<Word> get words => _words;
  List<Word> get filteredWords => _filteredWords;

  set currentWord(Word? word) {
    _currentWord = word;
    notifyListeners();
  }

  set selectedColor(WordColor color) {
    _selectedColor = color;
    _filteredWords = _words
        .where((word) => color == WordColor.all || word.color == color)
        .toList();
    _currentWord = _filteredWords.isNotEmpty ? _filteredWords[0] : _currentWord;
    notifyListeners();
  }

  void nextWord() {
    int index = _filteredWords
        .indexWhere((word) => word.english == _currentWord!.english);
    if (index == _filteredWords.length - 1) {
      _currentWord = _filteredWords[0];
    } else {
      _currentWord = _filteredWords[index + 1];
    }
    notifyListeners();
  }

  void previousWord() {
    int index = _filteredWords
        .indexWhere((word) => word.english == _currentWord!.english);
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
    if (index != -1) {
      _words[index] = word;
      int filteredIndex = _filteredWords
          .indexWhere((element) => element.english == englishValue);
      if (filteredIndex != -1) {
        _filteredWords[filteredIndex] = word;
      }
      if (_currentWord?.english == englishValue) {
        _currentWord = word;
      }
      notifyListeners();
      saveWords();
    } else {
      // Handle error: English value not found
    }
  }

  void saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'words',
        _words
            .map((word) => jsonEncode({
                  'english': word.english,
                  'hebrew': word.hebrew,
                  'color': word.color.name,
                }))
            .toList());
  }

  void loadWords() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? wordsJson = prefs.getStringList('words');
      if (wordsJson != null) {
        _words = wordsJson.map((wordJson) {
          var wordMap = jsonDecode(wordJson);
          return Word(
            english: wordMap['english'],
            hebrew: wordMap['hebrew'],
            color: WordColor.values
                .firstWhere((color) => color.name == wordMap['color']),
          );
        }).toList();
        _filteredWords = _words;
      }

      if (_words.isEmpty) {
        _words = nextQuizWords;
        _filteredWords = _words;
        saveWords();
      }

      _selectedColor = WordColor.all;
      _currentWord = _filteredWords.isNotEmpty ? _filteredWords[0] : null;
      notifyListeners();
    } catch (e) {
      // Handle error loading words
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

  void sortWords() {
    _words.sort((a, b) => a.english.compareTo(b.english));
    notifyListeners();
  }
}
