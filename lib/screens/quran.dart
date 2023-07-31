// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:gsg_project2_quran_app/models/ayah_model.dart';
import 'package:gsg_project2_quran_app/services/network.dart';

import '../widgets/my_bottom_sheet.dart';

// ignore: must_be_immutable
class Quran extends StatefulWidget {
  List<List<Ayah>> pagesAyahs;
  Quran({
    Key? key,
    required this.pagesAyahs,
  }) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  String bamala = "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏";
  Network network = Network();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        drawer: const Drawer(
          child: Column(),
        ),
        body: PageView.builder(
            itemCount: 604,
            itemBuilder: (context, index) {
              List<InlineSpan> textspanList = [];
              Set<String?> surahsName = {};
              Set<int?> jozz = {};

              for (Ayah ayah in widget.pagesAyahs[index]) {
                surahsName.add(ayah.suraNameAr);
                jozz.add(ayah.jozz);

                if (ayah.ayaNo == 1) {
                  textspanList.add(
                    WidgetSpan(
                        child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${surahsName.first}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                    )),
                  );
                }

                if (ayah.suraNameAr != "الفَاتِحة" &&
                    ayah.suraNameAr != "التوبَة" &&
                    ayah.ayaNo == 1) {
                  textspanList.add(WidgetSpan(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        bamala,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )));
                }

                textspanList.add(TextSpan(
                    recognizer: LongPressGestureRecognizer(
                        duration: const Duration(milliseconds: 200))
                      ..onLongPress = () async {
                        Map<String, dynamic> tafseer =
                            await network.getTafseer(ayah.suraNo!, ayah.ayaNo!);
                        if (mounted) {
                          return showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return MyBottomSheet(
                                    tfseer: tafseer,
                                    ayah: ayah.ayaText!,
                                    ayahId: ayah.id!);
                              });
                        }
                      },
                    text: ayah.ayaText,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)));
              }
              return Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${surahsName.first}"),
                      Text(" الجزء${jozz.first}")
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text.rich(
                    TextSpan(
                      children: textspanList,
                    ),
                  ),
                ),
                const Spacer(),
                Text("${index + 1}")
              ]);
            }),
      ),
    );
  }
}
