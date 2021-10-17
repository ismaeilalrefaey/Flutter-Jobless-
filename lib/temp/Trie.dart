//@dart=2.9
/// --- Trie File --- ///

/* * * * * * * * * * *  Trie  * * * * * * * * * * * * *
* Data Structure that allow inserting words inside it *
* and it can get all words that start with specific   *
* Prefix in linear time complexity = O(n + m), where: *
*     n = length of the prefix string                 *
*     m = number of nodes of prefix's subtree         *
* * * * * * * * * * * * * ** * * * * * * * * * * * * */

import '../temp.dart';

import 'Vertex.dart';

class Trie {
  /// ===================================================================== ///
  /// ============================== Private ============================== ///
  /// ===================================================================== ///
  List<String> _queryRes;
  String _word;
  Vertex _root;

  // recursively insert function
  void _insert(Vertex cur, int i) {
    if (i == this._word.length) {
      cur.exist = true;
      return;
    }
    String char = this._word[i];
    if (cur.child[char] == null) {
      cur.child[char] = new Vertex(char);
    }
    _insert(cur.child[char], i + 1);
  }

  // recursively get all words function
  void _getAll(Vertex cur, String s) {
    if (cur.exist == true) {
      this._queryRes.add(s);
    }
    if (cur.child.isNotEmpty) {
      cur.child.forEach((key, value) {
        _getAll(value, s + value.alphabet);
      });
    }
  }

  // recursively get all words with common prefix function
  void _getAllWithPrefix(Vertex cur, String s, int i, String prefix) {
    if (i == prefix.length) {
      if (cur.exist == true) {
        _queryRes.add(s);
      }
      if (cur.child.isNotEmpty) {
        cur.child.forEach((key, value) {
          _getAllWithPrefix(value, s + value.alphabet, i, prefix);
        });
      }
    } else {
      String char = prefix[i];
      if (cur.child[char] != null) {
        _getAllWithPrefix(cur.child[char], s + char, i + 1, prefix);
      }
    }
  }

  // recursively print all words function
  void _printALl(Vertex cur, String s) {
    if (cur.exist == true) {
      print(s);
    }
    if (cur.child.isNotEmpty) {
      cur.child.forEach((key, value) {
        _printALl(value, s + value.alphabet);
      });
    }
  }

  /// ==================================================================== ///
  /// ============================== Public ============================== ///
  /// ==================================================================== ///

  // constructor
  Trie() {
    _root = new Vertex('#');
    dictionary.forEach((element) {
      insert(element);
    });
  }

  // Function to insert one word into the Trie
  // The function call another Recursively Function
  void insert(String word) {
    this._word = word;
    _insert(_root, 0);
  }

  // Function to get all words from the Trie
  // The function call another Recursively Function
  List<String> getAll() {
    this._queryRes = [];

    _getAll(_root, "");
    return this._queryRes;
  }

  // Function to get words that has a common Prefix
  // The function call another Recursively Function
  List<String> getAllWithPrefix(String prefix) {
    this._queryRes = [];

    _getAllWithPrefix(_root, "", 0, prefix);
    return this._queryRes;
  }

  // Function to print all words from the Trie
  // The function call another Recursively Function
  void printAll() {
    _printALl(_root, "");
  }
}
