import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
import 'package:noam_learns_english/widgets/rating_buttons.dart';
import 'package:provider/provider.dart';

class WordsBankPage extends StatefulWidget {
  const WordsBankPage({super.key});

  @override
  State<WordsBankPage> createState() => _WordsBankPageState();
}

class _WordsBankPageState extends State<WordsBankPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String _english = '';
  String _hebrew = '';

  @override
  Widget build(BuildContext context) {
    var wordsProvider = Provider.of<WordsProvider>(context);
    var words = wordsProvider.words;

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Words',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                var word = words[index];
                return ListTile(
                  title: Text(word.english),
                  subtitle: Text(word.hebrew),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      wordsProvider.deleteWord(index);
                    },
                  ),
                  tileColor: word.color == 'green'
                      ? Colors.green.shade100
                      : word.color == 'yellow'
                          ? Colors.yellow.shade100
                          : Colors.red.shade100,
                  onTap: () {
                    _english = word.english;
                    _hebrew = word.hebrew;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Form(
                          key: _formKey1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                initialValue: _english,
                                decoration:
                                    const InputDecoration(labelText: 'English'),
                                onChanged: (value) {
                                  _english = value;
                                },
                              ),
                              TextFormField(
                                initialValue: _hebrew,
                                decoration:
                                    const InputDecoration(labelText: 'Hebrew'),
                                onChanged: (value) {
                                  _hebrew = value;
                                },
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey1.currentState!.validate()) {
                                    wordsProvider.updateWord(
                                        index,
                                        Word(
                                          english: _english,
                                          hebrew: _hebrew,
                                        ));
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Save'),
                              ),
                              RatingButtons(wordsProvider: wordsProvider, currentIndex: index, currentWord: word)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                    width: 1.0,
                    color: Colors.black),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'English'),
                      onChanged: (value) {
                        _english = value;
                      },
                    ),
                    TextFormField(
                      // make the text direction right-to-left
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(labelText: 'Hebrew'),
                      onChanged: (value) {
                        _hebrew = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey2.currentState!.validate()) {
                          wordsProvider.addWord(
                              Word(english: _english, hebrew: _hebrew));
                          _formKey2.currentState!.reset();
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      child: const Text('Add Word'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
