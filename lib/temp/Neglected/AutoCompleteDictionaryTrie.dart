//@dart=2.9
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../temp.dart';
import 'TrieNode.dart';

/// An trie data structure that implements the Dictionary and the AutoComplete ADT
/// @author You
///
class AutoCompleteDictionaryTrie {
  TrieNode _root;
  int _size;

  int size() => _size;

  AutoCompleteDictionaryTrie() {
    _root = new TrieNode('');
    _size = 0;
  }

  void preMadeDictionary() {
    dictionary.forEach((element) {
      addWord(element);
    });
  }

  bool addWord(String word) {
    if (word.length == 0) {
      return false;
    }
    TrieNode previous = _root;
    word = word.toLowerCase();
    Characters chars = word.characters;
    for (int i = 0; i < chars.length; i++) {
      Characters c = chars.characterAt(i);
      TrieNode current = previous.getChild(c);
      if (current == null) {
        current = previous.insert(c);
      }
      previous = current;
    }
    if (previous != null && !previous.endsWord()) {
      previous.setEndsWord(true);
      _size++;
      return true;
    } else {
      return false;
    }
  }

  bool isWord(String s) {
    TrieNode previous = _root;
    s = s.toLowerCase();
    Characters chars = s.characters;
    for (int i = 0; i < chars.length; i++) {
      Characters c = chars.characterAt(i);
      TrieNode current = previous.getChild(c);
      if (current == null && !s.endsWith('' + c.toString())) {
        return false;
      }
      previous = current;
    }
    if (previous != null) {
      return previous.endsWord();
    } else {
      return false;
    }
  }

  List<String> predictCompletions(String prefix, int numCompletions) {
    prefix = prefix.toLowerCase();
    List<String> suggestions = [];
    TrieNode previous = _root;
    Characters chars = prefix.characters;
    for (int i = 0; i < chars.length; i++) {
      Characters c = chars.characterAt(i);
      TrieNode current = previous.getChild(c);
      if (current == null) {
        return suggestions;
      }
      previous = current;
    }
    Queue<TrieNode> Q = new Queue();
    Q.add(previous);
    while (Q.isNotEmpty && numCompletions > 0) {
      TrieNode temp = Q.removeFirst();
      if (temp.endsWord()) {
        numCompletions--;
        suggestions.add(temp.getText());
      }
      Set<Characters> chars = temp.getValidNextCharacters();
      for (int i = 0; i < chars.length; i++) {
        Characters c = chars.elementAt(i);
        Q.add(temp.getChild(c));
      }
    }
    return suggestions;
  }

  void printTree() {
    printNode(_root);
  }

  void printNode(TrieNode curr) {
    if (curr == null) return;

    print(curr.getText());

    TrieNode next;
    Set<Characters> chars = curr.getValidNextCharacters();
    for (int i = 0; i < chars.length; i++) {
      Characters c = chars.elementAt(i);
      next = curr.getChild(c);
      printNode(next);
    }
  }
}
