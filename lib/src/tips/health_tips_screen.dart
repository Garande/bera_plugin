import 'package:flutter/material.dart';
// import 'package:kazi_mobile/utils/api_helper.dart';

import '../models/health_tip.dart';
import '../common/api_helper.dart';
import '../common/app_palette.dart';
import 'tips_screen.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({Key? key, required this.apiKey}) : super(key: key);
  final String apiKey;

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  Future<List<HealthTip>> fetchHealthTips() {
    // return ApiHelper.collection('/MAIN/ACTIVITIES/HEALTH_TIPS').get().then(
    //     (value) =>
    //         value.docs.map((e) => HealthTip.fromJson(e.data())).toList());
    return ApiHelper.fetchData(
      url: '${ApiHelper.baseURL}/health-tips',
      apiKey: widget.apiKey,
    ).then((value) =>
        List.from(value['data']).map((e) => HealthTip.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45.0),
            _buildHeader(context),
            const SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder<List<HealthTip>>(
                future: fetchHealthTips(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<HealthTip> healthTips = snapshot.data ?? [];

                  if (healthTips.isEmpty) {
                    return Center(
                      child: Text(
                        'No tip found',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: healthTips.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      HealthTip tip = healthTips[index];
                      //
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 7.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: AppPalette.boxShadow(context),
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(5.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TipsScreen(
                                    tipId: tip.id,
                                    apiKey: widget.apiKey,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${tip.label}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 14.5,
                                        ),
                                  ),
                                  const SizedBox(height: 3.0),
                                  Text(
                                    '${tip.shortDescription}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontSize: 13.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Text(
          'HEALTH TIPS',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18.0,
              ),
        ),
        const SizedBox(
          height: 30,
          width: 30,
        )
      ],
    );
  }
}
