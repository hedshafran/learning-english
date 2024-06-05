enum WordColor {
  all('all', 'All'),
  green('green', 'Green'),
  yellow('yellow', 'Yellow'),
  red('red', 'Red'),
  newWord('new', 'New');

  final String value;
  final String name;
  const WordColor(this.value, this.name);
}

class Word {
  String english;
  String hebrew;
  WordColor color;
  Word({required this.english, required this.hebrew, this.color = WordColor.newWord});
}
