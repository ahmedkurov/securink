import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiChatService {
  // Your Gemini API key is embedded directly in the service
  // Replace this with your actual API key
  final String apiKey = "AIzaSyD2cQeF40C7YQvmjCxMKOhfjAIWH-mG4ZA";

  Future<String> sendMessage(String message) async {
    const String baseUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent";

    try {
      final response = await http.post(
        Uri.parse("$baseUrl?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": message
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Failed to connect to Gemini API: $e");
    }
  }
}