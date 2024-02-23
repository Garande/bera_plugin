import 'package:flutter/material.dart';

class QuickAccessCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final double? borderRadius;
  final Widget? icon;
  final Function()? onTap;
  final Color? color;
  const QuickAccessCard({
    Key? key,
    this.title,
    this.subtitle,
    this.gradientStartColor,
    this.gradientEndColor,
    this.height,
    thisidth,
    this.vectorBottom,
    this.vectorTop,
    this.borderRadius,
    this.icon,
    this.onTap,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap ?? () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              gradientStartColor ?? color ?? const Color(0xff441DFC),
              gradientEndColor ??
                  color?.withOpacity(.7) ??
                  const Color(0xff4E81EB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            const SizedBox(
              height: 125,
              width: 150,
            ),
            SizedBox(
              height: 125,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Row(
                      children: [
                        icon ?? Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
