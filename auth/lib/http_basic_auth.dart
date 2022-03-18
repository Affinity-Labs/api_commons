import 'dart:convert';

import 'authentication.dart';
import 'query_param.dart';

class HttpBasicAuth implements Authentication {
  String? username;
  String? password;

  @override
  void applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    final credentials = '${username ?? ''}:${password ?? ''}';
    headerParams['Authorization'] =
        'Basic ${base64.encode(utf8.encode(credentials))}';
  }
}
