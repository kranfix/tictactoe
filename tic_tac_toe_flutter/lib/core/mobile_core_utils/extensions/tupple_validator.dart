extension IntTupleContains on (int, int, int) {
  bool contains(int val) => $1 == val || $2 == val || $3 == val;
}
