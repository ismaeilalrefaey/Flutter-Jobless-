//@dart=2.9
import 'dart:collection';

import 'package:flutter/cupertino.dart';

class TrieNode {
  Map<Characters, TrieNode> children;
  String text;
  bool isWord;

  String getText() => text;
  bool endsWord() => isWord;
  TrieNode getChild(Characters c) => children[c];
  Set<Characters> getValidNextCharacters() {
    Set<Characters> keys = new Set <Characters>();
    children.forEach((key, value) {
      keys.add(key);
    });
    return keys;
  }

  TrieNode(String text) {
    children = new HashMap<Characters, TrieNode>();
    isWord = false;
    this.text = text;
  }

  TrieNode insert(Characters c) {
    if (children.containsKey(c)) {
      return null;
    }

    TrieNode next = new TrieNode(text + c.toString());
    children[c] = next;
    return next;
  }

  void setEndsWord(bool b) {
    isWord = b;
  }
}
