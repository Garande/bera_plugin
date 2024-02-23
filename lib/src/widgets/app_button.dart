import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  // const AppButton({
  //   Key? key,
  //   this.child,
  //   this.text,
  //   this.height = 45,
  //   this.width,
  //   this.borderRadius = 5.0,
  //   this.isOutlined = false,
  //   this.gradient,
  //   this.onTap,
  //   this.color,
  // }) : super(key: key);
  // final Widget? child;
  // final String? text;
  // final double? height, width;
  // final double borderRadius;
  // final bool isOutlined;
  // final Gradient? gradient;
  // final VoidCallback? onTap;
  // final Color? color;

  const AppButton({
    Key? key,
    this.child,
    this.text,
    this.height = 45,
    this.width,
    this.borderRadius = 5.0,
    this.isOutlined = false,
    this.fontSize = 16.0,
    this.gradient,
    this.onTap,
    this.color,
    this.fontWeight,
  }) : super(key: key);
  final Widget? child;
  final String? text;
  final double? height, width;
  final double borderRadius;
  final bool isOutlined;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined
            ? Border.all(
                color: color ?? Theme.of(context).primaryColor,
                width: 1.3,
              )
            : null,
      ),
      child: Material(
        color: !isOutlined && gradient == null
            ? color ?? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child != null
                  ? Expanded(child: child!)
                  : Text(
                      text ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: !isOutlined
                                ? Colors.white
                                : color ?? Theme.of(context).primaryColor,
                            // fontWeight: FontWeight.w500,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
