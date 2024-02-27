import 'package:bera_plugin/src/common/config.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    Key? key,
    this.fontSize = 24.0,
    this.title,
    this.onBack,
    this.color,
  }) : super(key: key);
  final String? title;
  final VoidCallback? onBack;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          onTap: onBack,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Text(
          title ?? Config.appName,
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
