import 'package:flutter_test/flutter_test.dart';
import 'package:dompet_kampus_global/core/constants/app_constants.dart';
import 'package:dompet_kampus_global/core/utils/currency_formatter.dart';

void main() {
  test('uses Dompet Kampus Global app constants', () {
    expect(AppConstants.appName, 'Dompet Kampus Global');
    expect(AppConstants.apiVersion, '/v1');
  });

  test('formats Indonesian Rupiah values', () {
    expect(CurrencyFormatter.format(250000), 'Rp250.000');
  });
}
