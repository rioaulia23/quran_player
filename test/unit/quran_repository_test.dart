import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/repositories/quran_repository.dart';

http.Response _utf8Response(Object body, int statusCode) {
  final bytes = utf8.encode(jsonEncode(body));
  return http.Response.bytes(
    bytes,
    statusCode,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

void main() {
  group('QuranRepository', () {
    test('fetchAllSurahs returns a list of Surahs on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, contains('/surah'));
        return _utf8Response({
          'code': 200,
          'status': 'OK',
          'data': [
            {
              'number': 1,
              'name': 'سُورَةُ ٱلْفَاتِحَةِ',
              'englishName': 'Al-Fatihah',
              'englishNameTranslation': 'The Opening',
              'numberOfAyahs': 7,
              'revelationType': 'Meccan',
            },
          ],
        }, 200);
      });

      final repository = QuranRepository(client: mockClient);
      final surahs = await repository.fetchAllSurahs();

      expect(surahs, hasLength(1));
      expect(surahs.first.englishName, 'Al-Fatihah');
    });

    test('fetchAllSurahs throws QuranRepositoryException on non-200 status',
        () async {
      final mockClient = MockClient(
        (_) async => http.Response('Internal Server Error', 500),
      );

      final repository = QuranRepository(client: mockClient);
      expect(
        () => repository.fetchAllSurahs(),
        throwsA(isA<QuranRepositoryException>()),
      );
    });

    test('Surah.fromJson parses all fields correctly', () {
      final json = {
        'number': 2,
        'name': 'سُورَةُ الْبَقَرَةِ',
        'englishName': 'Al-Baqarah',
        'englishNameTranslation': 'The Cow',
        'numberOfAyahs': 286,
        'revelationType': 'Medinan',
      };

      final surah = Surah.fromJson(json);
      expect(surah.number, 2);
      expect(surah.englishName, 'Al-Baqarah');
      expect(surah.numberOfAyahs, 286);
      expect(surah.revelationType, 'Medinan');
    });

    test('Surah.audioUrl returns correct CDN URL', () {
      const surah = Surah(
        number: 1,
        name: '',
        englishName: '',
        englishNameTranslation: '',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      );
      expect(
        surah.audioUrl,
        'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/1.mp3',
      );
    });
  });
}
