import 'dart:convert';  // JSON encode
import 'package:http/http.dart' as http;

class ApiService {
  // Veriyi gönderme fonksiyonu
  Future<void> sendData(Map<String, dynamic> data) async {
    final url = 'https://yourapi.com/upload'; // Burayı değiştirmelisiniz

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data), // JSON formatında veri gönderiyoruz
      );

      if (response.statusCode == 200) {
        print("Veri başarıyla gönderildi!");
      } else {
        print("Gönderme başarısız: ${response.statusCode}");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }
}
