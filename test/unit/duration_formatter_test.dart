import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/utils/duration_formatter.dart';

void main() {
  group('formatDuration', () {
    test('formats zero as 0:00', () {
      expect(formatDuration(Duration.zero), '0:00');
    });

    test('formats 65 seconds as 1:05', () {
      expect(formatDuration(const Duration(seconds: 65)), '1:05');
    });

    test('formats 3661 seconds as 1:01:01', () {
      expect(formatDuration(const Duration(seconds: 3661)), '1:01:01');
    });

    test('pads minutes when hours present', () {
      expect(
        formatDuration(const Duration(hours: 1, minutes: 5, seconds: 3)),
        '1:05:03',
      );
    });

    test('does not pad minutes when no hours', () {
      expect(formatDuration(const Duration(minutes: 4, seconds: 7)), '4:07');
    });
  });
}
