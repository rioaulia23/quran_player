import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranRepository {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  final http.Client _client;

  QuranRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Surah>> fetchAllSurahs() async {
    final uri = Uri.parse('$_baseUrl/surah');

    late http.Response response;
    try {
      response = await _client.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw const QuranRepositoryException('Request timed out'),
          );
    } catch (e) {
      if (e is QuranRepositoryException) rethrow;
      throw QuranRepositoryException('Network error: $e');
    }

    if (response.statusCode != 200) {
      throw QuranRepositoryException(
        'Failed to load surahs (HTTP ${response.statusCode})',
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final dataList = json['data'] as List<dynamic>;
      return dataList
          .map((item) => Surah.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw QuranRepositoryException('Failed to parse surahs: $e');
    }
  }

  Future<Surah> fetchSurah(int number) async {
    assert(number >= 1 && number <= 114);
    final uri = Uri.parse('$_baseUrl/surah/$number');

    late http.Response response;
    try {
      response = await _client.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw const QuranRepositoryException('Request timed out'),
          );
    } catch (e) {
      if (e is QuranRepositoryException) rethrow;
      throw QuranRepositoryException('Network error: $e');
    }

    if (response.statusCode != 200) {
      throw QuranRepositoryException(
        'Failed to load surah $number (HTTP ${response.statusCode})',
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Surah.fromJson(json['data'] as Map<String, dynamic>);
    } catch (e) {
      throw QuranRepositoryException('Failed to parse surah: $e');
    }
  }

  void dispose() => _client.close();
}

class QuranRepositoryException implements Exception {
  final String message;
  const QuranRepositoryException(this.message);

  @override
  String toString() => 'QuranRepositoryException: $message';
}
