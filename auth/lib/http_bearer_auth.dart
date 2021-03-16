import 'authentication.dart';
import 'query_param.dart';

typedef HttpBearerAuthProvider = String Function();

class HttpBearerAuth implements Authentication {
  HttpBearerAuth();

  dynamic _accessToken;

  dynamic get accessToken => _accessToken;

  // Add this method for compatibility
  void setAccessToken(dynamic accessToken) {
    accessToken(accessToken);
  }

  set accessToken(dynamic accessToken) {
    if (accessToken is! String && accessToken is! HttpBearerAuthProvider) {
      throw ArgumentError(
          'Type of Bearer accessToken should be a String or a String Function().');
    }
    this._accessToken = accessToken;
  }

  @override
  void applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    if (_accessToken is String) {
      headerParams['Authorization'] = 'Bearer $_accessToken';
    } else if (_accessToken is HttpBearerAuthProvider) {
      headerParams['Authorization'] = 'Bearer ${_accessToken()}';
    } else {
      throw ArgumentError(
          'Type of Bearer accessToken should be a String or a String Function().');
    }
  }
}
