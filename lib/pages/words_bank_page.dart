import 'package:flutter/material.dart';
import 'package:noam_learns_english/models/word.dart';
import 'package:noam_learns_english/providers/words_provider.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              wordsProvider.randomizeWords();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: words.length,
              itemBuilder: (context, index) {
                var word = words[index];
                return ListTile(
                  title: Text(word.english),
                  subtitle: Text(word.hebrew),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Word'),
                          content: const Text(
                              'Are you sure you want to delete this word?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                wordsProvider.deleteWord(index);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  tileColor: word.color == WordColor.green
                      ? Colors.green.shade100
                      : word.color == WordColor.yellow
                          ? Colors.yellow.shade100
                          : word.color == WordColor.red
                              ? Colors.red.shade100
                              : Colors.white,
                  onTap: () {
                    _english = word.english;
                    _hebrew = word.hebrew;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _formKey1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(10),
                                    ),
                                    onPressed: () {
                                      wordsProvider.currentWord = word;
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  TextFormField(
                                    validator: (value) =>
                                        value!.isEmpty ? 'Required' : null,
                                    initialValue: _english,
                                    decoration: const InputDecoration(
                                      labelText: 'English',
                                    ),
                                    onChanged: (value) {
                                      _english = value;
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                  TextFormField(
                                    validator: (value) =>
                                        value!.isEmpty ? 'Required' : null,
                                    textDirection: TextDirection.rtl,
                                    initialValue: _hebrew,
                                    decoration: const InputDecoration(
                                        labelText: 'Hebrew'),
                                    onChanged: (value) {
                                      _hebrew = value;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey1.currentState!.validate()) {
                                        wordsProvider.updateWord(
                                            word.english,
                                            Word(
                                              english: _english,
                                              hebrew: _hebrew,
                                              color: word.color,
                                            ));
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(color: Colors.grey, height: 0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5.0,
                ),
              ],
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      decoration: _inputDeciration(context, 'English'),
                      onChanged: (value) {
                        _english = value;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      textDirection: TextDirection.rtl,
                      decoration: _inputDeciration(context, 'Hebrew'),
                      onChanged: (value) {
                        _hebrew = value;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey2.currentState!.validate()) {
                          if (words.any((word) => word.english == _english)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Word already exists'),
                              ),
                            );
                            return;
                          }
                          wordsProvider.addWord(
                              Word(english: _english, hebrew: _hebrew));
                          _formKey2.currentState!.reset();
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      child: const Text('Add'),
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

  InputDecoration _inputDeciration(BuildContext context, String labelText) {
    return InputDecoration(
      labelText: labelText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      contentPadding: const EdgeInsets.all(6),
    );
  }
}
