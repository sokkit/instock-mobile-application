import 'dart:io';

import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instock_mobile/src/features/stats/data/milestone_dto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';

import '../../../theme/common_theme.dart';

class ShareSlide extends StatelessWidget {
  final String suggestionText;
  final MilestoneDto milestone;
  final Function hideFunction;

  const ShareSlide(
      {Key? key,
      required this.suggestionText,
      required this.milestone,
      required this.hideFunction})
      : super(key: key);

  Future<String> _downloadImage() async {
    var url = Uri.parse(milestone.imageUrl!);
    var response = await http.get(url);
    var directory = await getTemporaryDirectory();
    String imagePath = '${directory.path}/image.jpg';
    File imageFile = await File(imagePath).create(recursive: true);
    await imageFile.writeAsBytes(response.bodyBytes);
    return imagePath;
  }

  // Flutter lifecycle https://medium.flutterdevs.com/app-lifecycle-in-flutter-c248d894b830
  // Deletes image on end of lifecycle otherwise there are issues re-getting the issue
  // from AWS
  @override
  Future<void> dispose() async {
    File file = File(milestone.imageUrl!);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CommonTheme();

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.themeData.splashColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () async {
                      hideFunction();
                    },
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: theme.themeData.primaryColorLight,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                          child: Text(
                            suggestionText,
                            textAlign: TextAlign.center,
                            style:
                                theme.themeData.textTheme.displaySmall?.merge(
                              const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (milestone.imageUrl == null) {
                              SocialShare.shareOptions(
                                  "I just hit ${milestone.totalSales} sales on ${milestone.itemName}! ${Emojis.partyPopper}");
                            } else {
                              String imagePath = await _downloadImage();
                              SocialShare.shareOptions(
                                  "I just hit ${milestone.totalSales} sales on ${milestone.itemName}! ${Emojis.partyPopper}",
                                  imagePath: imagePath);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.shortcut,
                              size: 40,
                              color: theme.themeData.primaryColorLight,
                            ),
                          ),
                        ),
                        Text(
                          "Tap to share",
                          style: theme.themeData.textTheme.displaySmall?.merge(
                            const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
