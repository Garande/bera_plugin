import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_button.dart';

class EmptyListMessageView extends StatelessWidget {
  const EmptyListMessageView({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.actionButtonMessage,
    this.onActionBtnTap,
    this.hasButton = true,
    this.icon,
  }) : super(key: key);

  final String iconPath, title, description, actionButtonMessage;
  final VoidCallback? onActionBtnTap;
  final bool hasButton;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: _listHeight,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: icon ??
                SvgPicture.asset(
                  iconPath,
                  // ignore: deprecated_member_use
                  color: Colors.grey[400],
                  width: 80,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  // fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14.0,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(.8)),
          ),
          if (hasButton)
            const SizedBox(
              height: 20,
            ),
          if (hasButton)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AppButton(
                text: actionButtonMessage,
                // height: 48,
                onTap: onActionBtnTap,
              ),
            ),
        ],
      ),
    );
  }
}
