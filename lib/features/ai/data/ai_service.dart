import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:blindspot/core/error/failures.dart';

/// Holds the result of an AI categorisation request.
final class AiCategorizationResult {
  final String suggestedCategory;
  final List<String> suggestedTags;
  final double confidence;

  const AiCategorizationResult({
    required this.suggestedCategory,
    required this.suggestedTags,
    required this.confidence,
  });
}

/// Calls the Gemini API to automatically categorise financial entries
/// (invoices, subscriptions, insurance policies).
class AiService {
  AiService({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  final Dio _dio;
  final String _apiKey;

  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  /// Sends [name] and optional [amount] to Gemini and returns a suggested
  /// category, tags, and a confidence score.
  ///
  /// [type] describes the entry kind (e.g. "invoice", "subscription").
  ///
  /// Throws [AiFailure] when the network call or JSON parsing fails.
  Future<AiCategorizationResult> categorize({
    required String name,
    String? amount,
    required String type,
  }) async {
    final prompt = '''
You are a financial data categorizer for an expense tracking app.
Categorize this $type: "$name" with amount "${amount ?? 'unknown'}".

Respond with ONLY valid JSON (no markdown, no explanation):
{"category": "<one of: utilities, software, healthcare, finance, education, entertainment, food, travel, marketing, infrastructure, rent, insurance, other>", "tags": ["tag1", "tag2"], "confidence": 0.95}''';

    try {
      final response = await _dio.post(
        _baseUrl,
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        },
      );

      final text =
          response.data['candidates'][0]['content']['parts'][0]['text']
              as String;

      // Strip markdown code fences if present.
      final cleanText =
          text.replaceAll(RegExp(r'```json|```'), '').trim();

      final json = jsonDecode(cleanText) as Map<String, dynamic>;

      return AiCategorizationResult(
        suggestedCategory: json['category'] as String? ?? 'other',
        suggestedTags:
            List<String>.from(json['tags'] as List? ?? []),
        confidence:
            (json['confidence'] as num?)?.toDouble() ?? 0.8,
      );
    } catch (e) {
      throw AiFailure('AI categorization failed: $e');
    }
  }
}
