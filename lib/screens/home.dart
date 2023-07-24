// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsg_project2_quran_app/widgets/my_bottom_sheet.dart';
import 'package:gsg_project2_quran_app/services/network.dart';

import '../models/ayah_model.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  List<List<Ayah>> pages;
  HomeScreen({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double factor = 1;
  Color bgcolor = Colors.transparent;
  bool bgImage = false;
  Set surahsSet = <String>{};
  Set jozz = <int>{};
  bool firstOfsurah = false;
  bool basmalIsShown = false;
  String bamala = "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏";
  List<InlineSpan> childern = [];
  Network network = Network();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            body: PageView.builder(
              itemCount: 604,
              itemBuilder: (context, index) {
                for (Ayah ayah in widget.pages[index]) {
                  surahsSet.add(ayah.suraNameAr);
                  jozz.add(ayah.jozz);
                  if (ayah.ayaNo == 1) {
                    firstOfsurah = true;
                  } else {
                    firstOfsurah = false;
                  }
                }
                if (index == 0 || index == 1) {
                  bgImage = true;
                } else {
                  bgImage = false;
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      bgcolor = Colors.transparent;
                    });
                  },
                  child: Container(
                      padding: !bgImage ? const EdgeInsets.only(top: 68) : null,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(bgImage
                                  ? "assets/images/quran_back_ground_1.png"
                                  : "assets/images/quran_back_ground_2.png"),
                              fit: BoxFit.cover)),
                      child: Column(
                        mainAxisAlignment: bgImage
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: bgImage ? 4.0 : 50.0),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                    text:
                                        " ${widget.pages[index][0].suraNameAr}",
                                    style: const TextStyle(fontSize: 18)),
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onScaleUpdate: (d) {
                              setState(() {
                                factor = d.scale;
                              });
                            },
                            child: SizedBox(
                              height: bgImage ? 250 : 500,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        widget.pages[index][0].suraNameAr ==
                                                "الفَاتِحة"
                                            ? 24
                                            : 0,
                                    horizontal: bgImage ? 88.0 : 50),
                                child: SingleChildScrollView(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AutoSizeText.rich(
                                          textAlign: TextAlign.center,
                                          minFontSize: 18,
                                          TextSpan(children: [
                                            if (firstOfsurah) ...{},
                                            for (int i = 0;
                                                i < widget.pages[index].length;
                                                i++) ...{
                                              if (widget.pages[index][i]
                                                          .ayaNo ==
                                                      1 &&
                                                  widget.pages[index][i]
                                                          .suraNameAr !=
                                                      "الفَاتِحة" &&
                                                  widget.pages[index][i]
                                                          .suraNameAr !=
                                                      "التوبَة") ...{
                                                TextSpan(
                                                    text: "$bamala\n",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              },
                                              TextSpan(
                                                  text:
                                                      " ${widget.pages[index][i].ayaText}",
                                                  style: TextStyle(
                                                      backgroundColor: bgcolor),
                                                  recognizer:
                                                      LongPressGestureRecognizer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200))
                                                        ..onLongPress =
                                                            () async {
                                                          Map<String, dynamic>
                                                              tfseer =
                                                              await network.getTafseer(
                                                                  widget
                                                                      .pages[
                                                                          index]
                                                                          [i]
                                                                      .suraNo!,
                                                                  widget
                                                                      .pages[
                                                                          index]
                                                                          [i]
                                                                      .ayaNo!);
                                                          if (mounted) {
                                                            showModalBottomSheet(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                20))),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return MyBottomSheet(
                                                                    ayahId: widget
                                                                        .pages[
                                                                            index]
                                                                            [i]
                                                                        .id!,
                                                                    tfseer:
                                                                        tfseer,
                                                                    ayah: widget
                                                                        .pages[
                                                                            index]
                                                                            [i]
                                                                        .ayaText!,
                                                                  );
                                                                });
                                                          }
                                                        }),
                                            },
                                          ]),
                                          textScaleFactor: factor,
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffd2ac15)),
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ),
        ));
  }
}
