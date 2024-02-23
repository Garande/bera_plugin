import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/health_tip.dart';
import '../common/api_helper.dart';
import '../common/app_palette.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({
    Key? key,
    this.tipId,
    required this.apiKey,
  }) : super(key: key);
  final dynamic tipId;
  final String apiKey;

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String html = "";

  Widget renderDoc(text) {
    return Html(
      data: text,
      style: {
        'p': Style(
          fontFamily: AppPalette.fontName,
          fontSize: FontSize.medium,
          // fontWeight: FontWeight.w300,
        ),
        'h1': Style(fontFamily: AppPalette.fontName),
        'h2': Style(fontFamily: AppPalette.fontName),
        'h3': Style(fontFamily: AppPalette.fontName),
        'li': Style(
          margin: Margins.only(left: 10.0, top: 5.0),
          fontFamily: AppPalette.fontName,
          fontSize: FontSize.medium,
          // fontWeight: FontWeight.w300,
        ),
      },
    );
  }

  Future<HealthTip?> fetchHealthTipById(String? tipId) {
    return ApiHelper.fetchData(
      url: '${ApiHelper.baseURL}/health-tips/$tipId',
      apiKey: widget.apiKey,
    ).then((value) {
      return HealthTip.fromJson(Map.from(value['data']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder<HealthTip?>(
            future: fetchHealthTipById(widget.tipId),
            builder: (context, snapshot) {
              HealthTip? tip = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 45.0),
                  _buildAppBar(context, tip),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: tip == null
                          ? Container()
                          : renderDoc(
                              tip.description,
                            ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Row _buildAppBar(BuildContext context, HealthTip? tip) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Expanded(
          child: Text(
            tip?.label ?? 'Tip',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 20.0,
                ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
