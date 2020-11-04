import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final int imgId;
  final Function onTap;
  final String imgPath;

  ImageContainer({
    this.imgId,
    this.onTap,
    this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2 - 23;
    return GestureDetector(
      onTap: () {
        onTap(imgId);
      },
      child: Card(
        child: Image.asset(
          imgPath,
          width: width,
        ),
      ),
    );
  }
}
