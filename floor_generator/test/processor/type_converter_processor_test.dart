import 'package:floor_generator/processor/type_converter_processor.dart';
import 'package:floor_generator/value_object/type_converter.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  test('Creates type converter', () async {
    final classElement = await '''
      class DateTimeToIntConverter extends TypeConverter<DateTime, int> {
        @override
        int encode(DateTime value) {
          return value.millisecondsSinceEpoch;
        }
      
        @override
        DateTime decode(int databaseValue) {
          return DateTime.fromMillisecondsSinceEpoch(databaseValue);
        }
      }
    '''
        .asClassElement();

    final actual = TypeConverterProcessor(
      classElement,
      TypeConverterScope.dao,
    ).process();

    final expected = TypeConverter(
      'DateTimeToIntConverter',
      await 'DateTime.now()'.asDartType(),
      await '1'.asDartType(),
      TypeConverterScope.dao,
    );
    expect(actual, equals(expected));
  });
}