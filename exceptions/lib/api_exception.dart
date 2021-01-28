import 'dart:io';

class ApiException implements Exception {
  int code = 0;
  String message;
  Exception innerException;
  StackTrace stackTrace;

  ApiException(this.code, this.message);

  ApiException.withInner(
      this.code, this.message, this.innerException, this.stackTrace);

  String toString() {
    if (message == null) return "ApiException";

    if (innerException == null) {
      return "ApiException $code: $message";
    }

    return "ApiException $code: $message (Inner exception: $innerException)\n\n" +
        stackTrace.toString();
  }

  ///
  /// Provide reason for exception based on http status code value.
  /// This provides a reason for only a few common status codes.
  ///
  String reason({String resource = 'resource'}) {
    switch (code) {
      // 2xx
      case HttpStatus.ok:
        return 'Your request has been processed successfully';
      case HttpStatus.created:
        return 'The $resource has been created successfully';

      // 4xx
      case HttpStatus.badRequest:
        return "Your request couldn't be processed. Please try again";
      case HttpStatus.unauthorized:
        return 'Session expired. Please login to continue';
      case HttpStatus.forbidden:
        return 'Forbidden';
      case HttpStatus.notFound:
        return 'The requested $resource was not found';

      // 5xx
      case HttpStatus.internalServerError:
        return "Something went wrong on our side. We're working to fix it.";

      default:
        return message;
    }
  }
}
