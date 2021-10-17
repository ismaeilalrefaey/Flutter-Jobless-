//@dart=2.9
/// --- Vertex File --- ///
 
/* * * * * * * * * * *  Vertex  * * * * * * * * * * * *
*                                                     *
* The Vertex has 52 pointers to a Vertex such that:   *
*   - The first  26 idx to the upper case letters     *
*   - The second 26 idx to the lower case letters     *
*                                                     *
* * * * * * * * * * * * * ** * * * * * * * * * * * * */
 
class Vertex {
  Map<String , Vertex> child;
  final size = 26 * 2;
  String alphabet;
  bool exist;
 
  Vertex(String alphabet){
    this.exist    = false;
    this.alphabet = alphabet;
    this.child    = new Map();
  }
}
 