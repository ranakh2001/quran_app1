// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gsg_project2_quran_app/services/network.dart';
import 'package:audioplayers/audioplayers.dart';

// ignore: must_be_immutable
class MyBottomSheet extends StatefulWidget {
  Map<String, dynamic> tfseer;
  String ayah;
  int ayahId;
  MyBottomSheet({
    Key? key,
    required this.tfseer,
    required this.ayah,
    required this.ayahId,
  }) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool isplayed = false;
  Network network = Network();

  void playAudio() async {
    Map<String, dynamic> data = await network.getAudio(widget.ayahId);
    AudioPlayer player = AudioPlayer();
    if (isplayed) {
      await player.play(UrlSource(data["data"]["audio"]));
    } else {
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(
                              side: BorderSide(color: Colors.black)),
                        ),
                        onPressed: () {
                          setState(() {
                            isplayed = !isplayed;
                          });
                          playAudio();
                        },
                        child: Icon(
                          isplayed ? Icons.pause : Icons.play_arrow,
                          size: 32,
                          color: Colors.black,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "(${widget.ayah})",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${widget.tfseer["text"]}",
                  style: const TextStyle(fontSize: 16),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
