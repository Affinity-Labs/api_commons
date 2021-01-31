///
///
///
abstract class ErrorHandler {
  // Return true if you want to consume this exception and prevent the
  // exception from being rethrown, and false otherwise.
  bool consume(dynamic exception);
}
