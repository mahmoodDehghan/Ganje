import 'package:flutter/material.dart';

class ImageViewFromAsset extends StatelessWidget {
  final String imageAddress;
  final double height;
  final double width;
  final BoxFit fit;

  ImageViewFromAsset(this.imageAddress)
      : height = 64,
        width = 64,
        fit = BoxFit.cover;

  ImageViewFromAsset.withSize(
      {required this.imageAddress, required this.height, required this.width})
      : fit = BoxFit.cover;

  ImageViewFromAsset.squreSize(
      {required this.imageAddress, required double size})
      : width = size,
        height = size,
        fit = BoxFit.cover;

  ImageViewFromAsset.withCustomFit(
      {required this.imageAddress,
      required this.height,
      required this.width,
      required this.fit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: this.width,
        height: this.height,
        child: FittedBox(
          child: Image.asset(imageAddress),
          fit: this.fit,
        ));
  }
}
