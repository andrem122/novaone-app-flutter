void main() async {
  ///
  /// 0, 1, 1, 2, 3, 5, 8, 13
  int fib(int index) {
    if (index == 0) {
      return 0;
    } else if (index == 1) {
      return 1;
    }

    final sum = fib(index - 2) + fib(index - 1);
    return sum;
  }

  print(fib(6));
}
