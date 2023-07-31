import 'package:flutter/material.dart';
import 'package:gsg_project2_quran_app/screens/quran.dart';
import 'package:gsg_project2_quran_app/services/asset.dart';

import '../models/ayah_model.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Asset asset = Asset();
  List<List<Ayah>>? pages;

  void getData() async {
    pages = await asset.readFromJsonFile();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Quran(pagesAyahs: pages!);
      }));
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
