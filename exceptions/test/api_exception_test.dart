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
}
