///
///
///
abstract class ErrorHandler {
  // A callback method that is called for this handler to process this error
  // before it's rethrown to the caller.
  void handle(dynamic exception);
}
