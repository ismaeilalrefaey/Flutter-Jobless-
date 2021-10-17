//@dart=2.9

import 'dart:core';
import 'dart:collection';
import 'package:flutter/material.dart';
import '../temp/DictionaryHashSet.dart';

enum StringManipulation {
  insert,
  delete,
  substitute,
}

class NearbyWords {
  DictionaryHashSet dict;

  NearbyWords(DictionaryHashSet dict) {
    this.dict = dict;
  }

  List<String> distanceOne(String s, bool wordsOnly) {
    List<String> retList = [];
    swaps(s, retList, wordsOnly);
    insertions(s, retList, wordsOnly);
    substitution(s, retList, wordsOnly);
    deletions(s, retList, wordsOnly);
    return retList;
  }

  String manipulateString(
      int index, Characters charCode, String string, StringManipulation sm) {
    String answer = string.substring(0, index);
    sm == StringManipulation.substitute
        ? answer += charCode.toLowerCase().toString() +
            string.substring(index + 1, string.length)
        : sm == StringManipulation.insert
            ? answer += charCode.toLowerCase().toString() +
                string.substring(index, string.length)
            : answer += string.substring(index + 1, string.length);
    return answer;
  }

  void substitution(String s, List<String> currentList, bool wordsOnly) {
    for (int index = 0; index < s.length; index++) {
      for (int charCode = 65; charCode <= 90; charCode++) {
        String sb = manipulateString(
            index,
            String.fromCharCode(charCode).characters,
            s,
            StringManipulation.substitute);
        if (!currentList.contains(sb) &&
            (!wordsOnly || dict.isWord(sb)) &&
            s.compareTo(sb) != 0) {
          currentList.add(sb.toString());
        }
      }
    }
  }

  void insertions(String s, List<String> currentList, bool wordsOnly) {
    for (int index = 0; index <= s.length; index++) {
      for (int charCode = 65; charCode <= 90; charCode++) {
        String sb = manipulateString(
            index,
            String.fromCharCode(charCode).characters,
            s,
            StringManipulation.insert);
        if (!currentList.contains(sb) && !wordsOnly ||
            dict.isWord(sb) && s.compareTo(sb) != 0) {
          currentList.add(sb);
        }
      }
    }
  }

  void deletions(String s, List<String> currentList, bool wordsOnly) {
    for (int index = 0; index < s.length; index++) {
      String sb = manipulateString(index, null, s, StringManipulation.delete);
      if (!currentList.contains(sb) && !wordsOnly ||
          dict.isWord(sb) && s.compareTo(sb) != 0) {
        currentList.add(sb.toString());
      }
    }
  }

  void swaps(String s, List<String> currentList, bool wordsOnly) {
    for (int index = 0; index < s.length - 1; index++) {
      String sb = s;
      Characters chars = s.characters;
      Characters c1 = chars.characterAt(index),
          c2 = chars.characterAt(index + 1);
      sb = manipulateString(index, c2, s, StringManipulation.substitute);
      sb = manipulateString(index + 1, c1, s, StringManipulation.substitute);
      if (!currentList.contains(sb) && !wordsOnly ||
          dict.isWord(sb) && s.compareTo(sb) != 0) {
        currentList.add(sb.toString());
      }
    }
  }

  List<String> suggestions(String word, int numSuggestions) {
    // initial variables
    Queue<String> queue = new Queue<String>();
    HashSet<String> visited = new HashSet<String>();
    List<String> retList = [];

    queue.add(word);
    visited.add(word);

    while (numSuggestions > 0 && queue.isNotEmpty) {
      String current = queue.removeFirst();
      List<String> neighbors = distanceOne(current, true);
      neighbors.forEach((element) {
        if (!visited.contains(element)) {
          visited.add(element);
          queue.add(element);
          if (dict.isWord(element)) {
            retList.add(element);
            numSuggestions--;
          }
        }
      });
    }
    return retList;
  }
}
