import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApi {
  static Future<(String, http.Response)> geminiChatApi(
      {required List<Map<String, String>> messages, required String apiKey}) async {
    var prompt = {
      "contents": {"parts": messages}
    };
    try {
      var url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${apiKey}');
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
