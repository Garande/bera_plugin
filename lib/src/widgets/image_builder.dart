import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// enum ImageSource { asset, network }

// ignore: must_be_immutable
class ImageBuilder extends StatelessWidget {
  ImageBuilder({
    Key? key,
    this.file,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    // this.scale = 1.0,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    // this.cacheWidth,
    // this.cacheHeight,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    // this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);
  String? imageUrl;
  final BoxFit? fit;
  final double? width, height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry? alignment;
  final ImageRepeat? repeat;
  // final int cacheWidth, cacheHeight;
  final Map<String, String>? headers;
  final FilterQuality? filterQuality;
  File? file;

  final ImageFrameBuilder? frameBuilder;
  // final ImageLoadingBuilder loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  late Widget image;

  ImageBuilder.network(
    this.imageUrl, {
    Key? key,
    this.fit,
    this.width,
    this.height,
    double scale = 1,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    int? cacheWidth,
    int? cacheHeight,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    this.errorBuilder,
  })  : image = CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: fit,
          // filterQuality: filterQuality!,
          // frameBuilder: frameBuilder,
          height: height,
          width: width,
          memCacheHeight: cacheHeight,
          memCacheWidth: cacheWidth,
          repeat: repeat!,
          colorBlendMode: colorBlendMode,
          color: color,
          // scale: scale,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          errorWidget: (context, url, error) => const Center(
              child: Icon(
            Icons.error,
            color: Colors.redAccent,
          )),
        ),
        super(key: key);

  ImageBuilder.asset(
    this.imageUrl, {
    Key? key,
    this.fit,
    this.width,
    this.height,
    double scale = 1.0,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    int? cacheWidth,
    int? cacheHeight,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    this.errorBuilder,
  })  : image = Image.asset(
          imageUrl!,
          fit: fit,
          alignment: alignment!,
          filterQuality: filterQuality!,
          // frameBuilder: frameBuilder,
          height: height,
          width: width,
          cacheHeight: cacheHeight,
          cacheWidth: cacheWidth,
          repeat: repeat!,
          colorBlendMode: colorBlendMode,
          color: color,
          scale: scale,
          key: key,
          frameBuilder: frameBuilder ??
              (BuildContext context, Widget child, int? frame,
                  bool? wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded!) {
                  return child;
                }

                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
          errorBuilder: errorBuilder ??
              (BuildContext context, Object object, StackTrace? stackTrace) {
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                );
              },
        ),
        super(key: key);

  ImageBuilder.file(
    this.file, {
    Key? key,
    this.fit,
    this.width,
    this.height,
    double scale = 1.0,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    int? cacheWidth,
    int? cacheHeight,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    this.errorBuilder,
  })  : image = Image.file(
          file!,
          fit: fit,
          alignment: alignment!,
          filterQuality: filterQuality!,
          // frameBuilder: frameBuilder,
          height: height,
          width: width,
          cacheHeight: cacheHeight,
          cacheWidth: cacheWidth,
          repeat: repeat!,
          colorBlendMode: colorBlendMode,
          color: color,
          scale: scale,
          key: key,
          frameBuilder: frameBuilder ??
              (BuildContext context, Widget child, int? frame,
                  bool? wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded!) {
                  return child;
                }

                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
          errorBuilder: errorBuilder ??
              (BuildContext context, Object object, StackTrace? stackTrace) {
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                );
              },
        ),
        super(key: key);

  ImageBuilder.svgNetwork(
    String imageUrl, {
    Key? key,
    this.fit,
    this.width,
    this.height,
    double scale = 1,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    int? cacheWidth,
    int? cacheHeight,
    this.headers,
    this.filterQuality = FilterQuality.low,
    this.frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    this.errorBuilder,
  })  : image = SvgPicture.network(
          imageUrl,
          fit: fit ?? BoxFit.contain,
          // filterQuality: filterQuality!,
          // frameBuilder: frameBuilder,
          height: height,
          width: width,

          // colorBlendMode: colorBlendMode,
          // ignore: deprecated_member_use
          color: color,
          // progressIndicatorBuilder: ,
          // scale: scale,
          // placeholder: (context, url) => Center(
          //   child: CircularProgressIndicator(
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          // ),
          // errorWidget: (context, url, error) => Center(
          //     child: Icon(
          //   Icons.error,
          //   color: Colors.redAccent,
          // )),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
