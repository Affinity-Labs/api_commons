import 'package:exceptions/api_exception.dart';
import 'package:test/test.dart';

void main() {
  test('Parse message in exception when getting reason', () {
    final ApiException exception = ApiException(400, '''
        [{
	"errorCode": 400,
	"errorMsg": "Insufficient Balance",
	"errorField": null
}]
        ''');
    final String reason = exception.reason();
    expect(reason, 'Insufficient Balance');
  });

  test('Parse mangled message in exception when getting reason', () {
    final ApiException exception = ApiException(401, '''
Message: Unprocessable Content
HTTP response code: 422
HTTP response body: {"message":"The provided credentials are incorrect.","status":422}
HTTP response headers: {access-control-allow-headers=[Content-Type, Authorization, X-Requested-With, X-XSRF-TOKEN], access-control-allow-methods=[GET, POST, PUT, PATCH, DELETE, OPTIONS], access-control-allow-origin=[*], cache-control=[no-cache, private], connection=[keep-alive], content-type=[application/json], date=[Mon, 18 Jul 2022 15:25:50 GMT], server=[nginx], transfer-encoding=[chunked], x-ratelimit-limit=[60], x-ratelimit-remaining=[58]}
        ''');
    final String reason = exception.reason();
    expect(reason, 'The provided credentials are incorrect.');
  });
}
