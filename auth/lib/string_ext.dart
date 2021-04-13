extension NumberParsing on String {
  double parseDouble() {
    return double.parse(this);
  }

  double toDouble() {
    return parseDouble();
  }
  // ···
}
