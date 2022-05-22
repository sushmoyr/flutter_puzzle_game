// class Tuple3<A, B, C> {
//   final A item1;
//   final B item2;
//   final C item3;
//
//   Tuple3(this.item1, this.item2, this.item3);
//
//   factory Tuple3.fromList(List items) {
//     assert(items.length == 3, 'List length must be 3');
//
//     return Tuple3<A, B, C>(items[0], items[1], items[2]);
//   }
//
//   @override
//   String toString() {
//     return 'Tuple3{item1: $item1, item2: $item2, item3: $item3}';
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Tuple3 &&
//           runtimeType == other.runtimeType &&
//           item1 == other.item1 &&
//           item2 == other.item2 &&
//           item3 == other.item3;
//
//   @override
//   int get hashCode => item1.hashCode ^ item2.hashCode ^ item3.hashCode;
// }

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }

  operator [](int index) {
    if (index == 0) {
      return first;
    }
    if (index == 1) {
      return second;
    }
    throw RangeError('Index must be 0 or 1');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
