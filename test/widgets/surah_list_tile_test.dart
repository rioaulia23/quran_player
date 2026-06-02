import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/utils/app_theme.dart';
import 'package:quran_player/widgets/surah_list_tile.dart';

void main() {
  const testSurah = Surah(
    number: 1,
    name: 'سُورَةُ ٱلْفَاتِحَةِ',
    englishName: 'Al-Fatihah',
    englishNameTranslation: 'The Opening',
    numberOfAyahs: 7,
    revelationType: 'Meccan',
  );

  Widget buildTile({
    bool isSelected = false,
    bool isPlaying = false,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(
        body: SurahListTile(
          surah: testSurah,
          isSelected: isSelected,
          isPlaying: isPlaying,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('SurahListTile', () {
    testWidgets('displays surah english name', (tester) async {
      await tester.pumpWidget(buildTile());
      expect(find.text('Al-Fatihah'), findsOneWidget);
    });

    testWidgets('displays surah number', (tester) async {
      await tester.pumpWidget(buildTile());
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('shows play icon when not playing', (tester) async {
      await tester.pumpWidget(buildTile(isPlaying: false));
      expect(find.byIcon(Icons.play_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTile(onTap: () => tapped = true));
      await tester.tap(find.byType(SurahListTile));
      expect(tapped, isTrue);
    });

    testWidgets('shows revelation type in caption', (tester) async {
      await tester.pumpWidget(buildTile());
      expect(find.textContaining('Meccan'), findsOneWidget);
    });
  });
}
