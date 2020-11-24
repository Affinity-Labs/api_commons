import 'package:http/http.dart';

abstract class Interceptor<T> {
  Future<T> interceptResponse(Response response);
}
