import 'dart:convert';
import 'dart:io';

class ApiException implements Exception {
  int code = 0;
  String? message;
  Exception? innerException;
  StackTrace? stackTrace;

  Map<String, dynamic>? _jsonMap;
  ApiException(this.code, String? message) {
    _initJsonMap(message);
  }

  ApiException.withInner(
      this.code, String? message, this.innerException, this.stackTrace) {
    _initJsonMap(message);
  }

  void _initJsonMap(String? message) {
    if (message != null && message.isNotEmpty) {
      try {
        this.message = message;
        dynamic _decodedJson = jsonDecode(message);
        if (_decodedJson is List) {
          _jsonMap = _decodedJson[0];
        } else {
          _jsonMap = _decodedJson;
        }
      } catch (e) {
        _jsonMap = {};
        var matches = RegExp(r'({.+})').allMatches(message);
        for (var i = 0; i < matches.length; i++) {
          try {
            var group = matches.elementAt(i).group(0) ?? '';
            Map<String, dynamic> map = jsonDecode(group);
            _jsonMap?.addAll(map);
          } catch (_) {
            // Ignore error
          }
        }
        // Ignore error
      }
    }
  }

  String toRawString() {
    if (message == null) return "ApiException";

    if (innerException == null) {
      return "ApiException $code: $message";
    }

    return "ApiException $code: $message (Inner exception: $innerException)\n\n" +
        stackTrace.toString();
  }

  String toString() {
    return reason();
  }

  String action() {
    String? action;
    if (_jsonMap != null && _jsonMap!.containsKey('action')) {
      action = _jsonMap!['action'];
    }

    return action ?? '';
  }

  ///
  /// Provide reason for exception based on http status code value.
  /// This provides a reason for only a few common status codes.
  ///
  String reason({String resource = 'resource'}) {
    if (innerException != null && innerException is SocketException) {
      return 'Please check your internet connection and try again';
    }

    if (code == HttpStatus.internalServerError) {
      return "Something went wrong on our side. We’re working to fix it. [$code]";
    }

    if (code == HttpStatus.forbidden) {
      return 'Access denied. Please contact support for assistance. [$code]';
    }

    if (_jsonMap != null) {
      String? errorMsg;
      if (_jsonMap!.containsKey('errorMsg')) {
        errorMsg = _jsonMap!['errorMsg'];
      } else if (_jsonMap!.containsKey('message')) {
        errorMsg = _jsonMap!['message'];
      } else if (_jsonMap!.containsKey('errors')) {
        final errors = _jsonMap!['errors'];
        errorMsg = (errors is List && errors.isNotEmpty)
            ? errors.first.toString()
            : null;
        if ((errorMsg ?? '').isNotEmpty && _jsonMap!.containsKey('field')) {
          errorMsg = '${_jsonMap!["field"]}: $errorMsg';
        }
      }

      if (errorMsg != null && errorMsg.isNotEmpty) {
        return errorMsg;
      }
    }

    switch (code) {
      // 2xx
      case HttpStatus.ok:
        return 'Your request has been processed successfully';
      case HttpStatus.created:
        return 'The $resource has been created successfully';

      // 4xx
      case HttpStatus.badRequest:
      case HttpStatus.unprocessableEntity:
        return "Your request couldn’t be processed. Please try again";
      case HttpStatus.unauthorized:
        return 'Session expired. Please login to continue';
      case HttpStatus.forbidden:
        return 'Access denied. Please contact support for assistance.';
      case HttpStatus.notFound:
        return 'The requested $resource was not found';

      case HttpStatus.badGateway:
      case HttpStatus.gatewayTimeout:
        return "We're experiencing difficulties reaching Affinity. Please try again.";

      default:
        return message ?? '';
    }
  }
}
