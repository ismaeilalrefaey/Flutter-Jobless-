//@dart=2.9
import '../temp.dart';
import 'dart:collection';

class DictionaryHashSet {
  HashSet<String> words;

  DictionaryHashSet() {
    words = new HashSet<String>();
    dictionary.forEach((element) {
      words.add(element);
    });
  }

  bool addWord(String word) {
    return words.add(word.toLowerCase());
  }

  int size() => words.length;
  bool isWord(String s) => words.contains(s.toLowerCase());
}
