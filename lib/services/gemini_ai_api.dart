import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApi {
  /// Calls the Gemini AI API to generate content based on the provided messages and API key.
  ///
  /// The [messages] parameter is a list of maps, where each map represents a part of the message.
  /// Each map should have a "text" key with the corresponding text value.
  ///
  /// The [apiKey] parameter is the API key required to access the Gemini AI API.
  ///
  /// Returns a Future that completes with a tuple containing the generated content as a String
  /// and the HTTP response.
  /// If an error occurs, an empty string and an HTTP response with status code 500 will be returned.
  static Future<(String, http.Response)> geminiChatApi(
      {required List<Map<String, String>> messages, required String apiKey}) async {
    var prompt = {
      "contents": {"parts": messages}
    };
    try {
      var url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');
      var response = await http.post(url,
          body: json.encode(prompt),
          headers: {'Content-Type': 'application/json'});
      final decodedResponse = json.decode(response.body);
      return (
        decodedResponse['candidates'][0]['content']["parts"][0]["text"]
            .toString(),
        response
      );
    } catch (e) {
      return ("", http.Response("Error", 500));
    }
  }
}
