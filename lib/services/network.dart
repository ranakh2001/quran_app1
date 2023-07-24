import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  Future<Map<String, dynamic>> getTafseer(int surahNum, int ayahNum) async {
    http.Response response = await http.get(
        Uri.parse("http://api.quran-tafseer.com/tafseer/1/$surahNum/$ayahNum"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      return Future.error("something wrong");
    }
  }

  Future<Map<String, dynamic>> getAudio(int id) async {
    http.Response response =
        await http.get(Uri.parse("https://api.alquran.cloud/v1/ayah/$id/ar.alafasy"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      return Future.error("something wrong");
    }
  }
}
