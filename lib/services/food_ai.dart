import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/meal.dart';

/// Sends a meal photo to Gemini and gets the nutrition back as JSON.
class FoodAI {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _model = 'gemini-3.5-flash-lite';

  static const _prompt = 'You are a nutrition expert. Look at this meal photo. '
      'Name the dish and estimate the whole portion you can see: calories, '
      'protein, carbs and fat in grams, a health score from 1 to 10, '
      'and up to 6 main ingredients.';

  static const _schema = {
    'type': 'OBJECT',
    'properties': {
      'name': {'type': 'STRING'},
      'calories': {'type': 'INTEGER'},
      'protein': {'type': 'INTEGER'},
      'carbs': {'type': 'INTEGER'},
      'fat': {'type': 'INTEGER'},
      'healthScore': {'type': 'INTEGER'},
      'ingredients': {
        'type': 'ARRAY',
        'items': {'type': 'STRING'},
      },
    },
    'required': ['name', 'calories', 'protein', 'carbs', 'fat', 'healthScore', 'ingredients'],
  };

  static Future<Meal> analyze(Uint8List photo, String mimeType) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
    );
    final body = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {'mime_type': mimeType, 'data': base64Encode(photo)},
            },
            {'text': _prompt},
          ],
        },
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': _schema,
      },
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'x-goog-api-key': _apiKey},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}');
    }

    final text = jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text'];
    return Meal.fromJson(jsonDecode(text), photo);
  }
}
