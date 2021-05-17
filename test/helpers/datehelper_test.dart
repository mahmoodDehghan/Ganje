import '../../lib/helpers/datehelper.dart';
import 'package:test/test.dart';

void main() {
  group('date convertions test', () {
    test('convert date to string test', () {
      var date = DateTime.parse('2021-04-04 19:53:05Z');
      expect(DateHelper.normalDateToString(date), '4/4/2021');
    });
    test('convert string to date test', () {
      var stringDate = '4/4/2021';
      var date = DateTime.parse('2021-04-04 00:00:00');
      expect(DateHelper.normalStringToDate(stringDate), date);
    });
  });
}
