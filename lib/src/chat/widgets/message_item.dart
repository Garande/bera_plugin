// import 'package:bera_app/models/message.dart';
// import 'package:bera_app/utils/app_palette.dart';
// import 'package:bera_app/utils/config.dart';
// import 'package:bera_app/utils/helpers.dart';
// import 'package:bera_app/widgets/image_builder.dart';
// import 'package:bera_app/widgets/video/video_preview.dart';
// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/message.dart';
import '../../common/config.dart';
import '../../common/helpers.dart';
import '../../widgets/image_builder.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    this.myId,
    required this.message,
    required this.index,
    required this.messages,
  }) : super(key: key);
  final int? myId;
  final Message message;
  final int index;
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    if (Helpers.isOwnMessage(userId: myId, idFrom: message.userId)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ..._buildMessages(message, index, messages, false, context),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._buildMessages(message, index, messages, true, context),
        ],
      );
    }
  }

  List<Widget> _buildMessages(
    Message message,
    int index,
    List<Message> messages,
    bool isLeft,
    BuildContext context,
  ) {
    return <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: 100.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),

            // width: 200.0,
            decoration: BoxDecoration(
              color: isLeft
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColorDark, //Colors.blueGrey[100],
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.only(
              bottom: (index == (messages.length - 1)) ? 20.0 : 10.0,
              right: 6.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: <Widget>[
                if (message.type == MessageType.IMAGE)
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200.0,
                      maxWidth: 200.0,
                    ),
                    child: Material(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      clipBehavior: Clip.hardEdge,
                      child: ImageBuilder.network(
                        message.content ?? '',
                        width: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (message.type == MessageType.LOCATION)
                  getLocationMessage(message),
                // if (message.type == MessageType.VIDEO)
                //   getVideoMessage(message, context),
                if (message.type == MessageType.TEXT)
                  renderMessage(
                    message: message.content ?? 'message',
                    color: !isLeft ? Colors.white : null,
                    isLeft: isLeft,
                  ),

                // Text(
                //     message.content ?? 'message',
                //     textAlign: isLeft ? TextAlign.start : TextAlign.end,
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyLarge
                //         ?.copyWith(color: !isLeft ? Colors.white : null),
                //   ),
                Align(
                  alignment:
                      isLeft ? Alignment.bottomLeft : Alignment.bottomRight,
                  widthFactor: 1,
                  child: Container(
                    // width: 50,
                    margin: const EdgeInsets.only(
                      top: 2.0,
                      bottom: 5.0,
                    ),
                    // width: 50,
                    child: Text(
                      getMessageTime(message.creationDateTimeMillis),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: !isLeft ? Colors.grey[400] : null),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  // Widget getVideoMessage(Message message, BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PreviewVideo(
  //             isdownloadallowed: true,
  //             filename: "Video-${DateTime.now().millisecondsSinceEpoch}.mp4",
  //             id: null,
  //             videourl: message.content ?? '',
  //             // aspectratio: meta!["width"] / meta["height"],
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       color: Colors.blueGrey,
  //       height: 197,
  //       width: 197,
  //       child: Stack(
  //         children: [
  //           ImageBuilder.network(
  //             message.content,
  //             errorBuilder: (context, error, stackTrace) {
  //               return Material(
  //                 borderRadius: const BorderRadius.all(
  //                   Radius.circular(0.0),
  //                 ),
  //                 clipBehavior: Clip.hardEdge,
  //                 child: Image.asset(
  //                   'assets/images/img_not_available.jpeg',
  //                   width: 197,
  //                   height: 197,
  //                   fit: BoxFit.cover,
  //                 ),
  //               );
  //             },
  //             loadingBuilder: (ctx, _, __) {
  //               return Container(
  //                 width: 197,
  //                 height: 197,
  //                 padding: const EdgeInsets.all(80.0),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.blueGrey,
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(0.0),
  //                   ),
  //                 ),
  //                 child: CircularProgressIndicator(
  //                   valueColor:
  //                       AlwaysStoppedAnimation<Color>(Colors.blueGrey[400]!),
  //                 ),
  //               );
  //             },
  //             width: 197,
  //             height: 197,
  //             fit: BoxFit.cover,
  //           ),
  //           Container(
  //             color: Colors.black.withOpacity(0.4),
  //             height: 197,
  //             width: 197,
  //           ),
  //           const Center(
  //             child: Icon(
  //               Icons.play_circle_fill_outlined,
  //               color: Colors.white70,
  //               size: 65,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget getLocationMessage(Message message) {
    return InkWell(
      onTap: () {
        custom_url_launcher(message.content ?? '');
      },
      child: ImageBuilder.asset(
        'assets/images/backgrounds/mapview.jpg',
      ),
    );
  }

  void custom_url_launcher(String url) async {
    if (url.startsWith("http")) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) throw 'Could not launch $url';
    } else {
      var newUrl = "http://$url";
      if (!await launchUrl(Uri.parse(newUrl),
          mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $newUrl';
      }
    }
  }

  Widget renderMessage({
    String? message,
    Color? color,
    required bool isLeft,
  }) {
    return ClickableMessage(
      message: message ?? 'message',
      color: color,
      isLeft: isLeft,
    );
    // return Html(
    //   data: message,
    //   style: {
    //     'p': Style(
    //       fontFamily: AppPalette.fontName,
    //       fontSize: FontSize.medium,
    //       alignment: isLeft
    //       // fontWeight: FontWeight.w300,
    //     ),
    //     'h1': Style(fontFamily: AppPalette.fontName),
    //     'h2': Style(fontFamily: AppPalette.fontName),
    //     'h3': Style(fontFamily: AppPalette.fontName),
    //     'li': Style(
    //       margin: Margins.only(left: 10.0, top: 5.0),
    //       fontFamily: AppPalette.fontName,
    //       fontSize: FontSize.medium,
    //       // fontWeight: FontWeight.w300,
    //     ),
    //   },
    // );
  }

  String getMessageTime(int? timestamp) {
    var lastDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp ?? 0);

    // new DateFormat.yMMMMd("en_US")
    var today = DateTime.now();
    // var diff = today.difference(lastDateTime);

    var dateFullFormat = DateFormat.yMMMd("en_US");
    var dateShortFormat = DateFormat.MMMd("en_US");
    var format = DateFormat('HH:mm');

    var time = '';
    var date = '';

    // var months

    time = format.format(lastDateTime);

    if (today.year > lastDateTime.year) {
      date = dateFullFormat.format(lastDateTime);
    } else if (today.year == lastDateTime.year) {
      if ((today.day - lastDateTime.day) == 0 &&
          lastDateTime.month == today.month) {
        date = 'Today';
      } else if ((today.day - lastDateTime.day) == 1 &&
          lastDateTime.month == today.month) {
        date = 'Yesterday';
      } else {
        date = dateShortFormat.format(lastDateTime);
      }
    }

    return '$date, ${time.toLowerCase()}';
  }
}

class ClickableMessage extends StatelessWidget {
  final String message;
  final Color? color;
  final bool? isLeft;

  const ClickableMessage({
    super.key,
    required this.message,
    this.color,
    this.isLeft,
  });

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    RegExp linkRegExp = RegExp(r'https?://[^\s]+');
    Iterable<RegExpMatch> matches = linkRegExp.allMatches(message);

    int currentPos = 0;

    for (RegExpMatch match in matches) {
      if (match.start > currentPos) {
        textSpans.add(
          TextSpan(
            text: message.substring(currentPos, match.start),
          ),
        );
      }

      String link = match.group(0)!;
      textSpans.add(
        TextSpan(
          text: link,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.orangeAccent,
                decoration: TextDecoration.underline,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchURL(link);
            },
        ),
      );

      currentPos = match.end;
    }

    if (currentPos < message.length) {
      textSpans.add(
        TextSpan(
          text: message.substring(currentPos),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
              ),
        ),
      );
    }

    return RichText(
      textAlign:
          isLeft == null || isLeft == true ? TextAlign.start : TextAlign.end,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
