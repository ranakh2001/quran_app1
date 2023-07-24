import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ayah_model.dart';

class Asset {
  Future<List<List<Ayah>>> readFromJsonFile() async {
    List<List<Ayah>> pageAyahs = [];
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    if (response.isNotEmpty) {
      List<dynamic> ayahs = json.decode(response);
      for (int i = 1; i < 604; i++) {
        List<Ayah> temp = [];
        ayahs.forEach((element) {
          if (element["page"] == i) {
            temp.add(Ayah.fromJson(element));
          }
        });
        pageAyahs.add(temp);
      }
      return pageAyahs;
    } else {
      return Future.error("error");
    }
  }
}
