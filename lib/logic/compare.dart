import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as pacImage;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solid_test/screens/home.dart';

class Compare {
  List<Color> fColors = List<Color>();
  List<Color> sColors = List<Color>();

  void clearColorsDiffLists() {
    fColors.clear();
    sColors.clear();
  }

  replaceImg(String firstImgPath, int imgId, String secondImgPath) async {
    String secondFullImgPath = imgWrongPathList[imgId];
    String firstFullImgPath = imgCorrectPathList[imgId];
    Directory directory = await getApplicationDocumentsDirectory();
    String firstImgTitle =
        firstFullImgPath.substring(firstFullImgPath.lastIndexOf('/') + 1);
    String secondImgTitle =
        secondFullImgPath.substring(firstFullImgPath.lastIndexOf('/') + 1);
    var firstPath = join(directory.path, firstImgTitle);
    var secondPath = join(directory.path, secondImgTitle);
    if (FileSystemEntity.typeSync(firstPath) == FileSystemEntityType.notFound) {
      ByteData firstImgData = await rootBundle.load(firstFullImgPath);
      writeToFile(firstImgData, firstPath);
    }
    if (FileSystemEntity.typeSync(secondPath) ==
        FileSystemEntityType.notFound) {
      ByteData secondImgData = await rootBundle.load(secondFullImgPath);
      writeToFile(secondImgData, secondPath);
    }
    getImgFile(firstPath, secondPath);
  }

  void writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void getImgFile(String firstImagePath, String secondImagePath) async {
    pacImage.Image firstImage =
        pacImage.decodeImage(File(firstImagePath).readAsBytesSync());
    pacImage.Image secondImage =
        pacImage.decodeImage(File(secondImagePath).readAsBytesSync());
    for (int i = 0; i < firstImage.width; i += 4) {
      var firstPixel, secondPixel;
      for (int j = 0; j < firstImage.height; j++) {
        firstPixel = firstImage.getPixel(i, j);
        secondPixel = secondImage.getPixel(i, j);
        _diffBetweenPixels(firstPixel, secondPixel, i, j);
      }
    }
  }

  void _diffBetweenPixels(firstPixel, secondPixel, int i, int j) {
    var fRed = pacImage.getRed(firstPixel);
    var fGreen = pacImage.getGreen(firstPixel);
    var fBlue = pacImage.getBlue(firstPixel);
    var sRed = pacImage.getRed(secondPixel);
    var sGreen = pacImage.getGreen(secondPixel);
    var sBlue = pacImage.getBlue(secondPixel);
    Color fColor = getBasicColor(fRed, fGreen, fBlue);
    Color sColor = getBasicColor(sRed, sGreen, sBlue);
    if (fColor != sColor && fColor != null && sColor != null) {
      if (!fColors.contains(fColor) || !sColors.contains(sColor)) {
        fColors.add(fColor);
        sColors.add(sColor);
      }
    }
  }

  Color getBasicColor(var red, var green, var blue) {
    if (red <= 51 && green <= 51 && blue <= 51) {
      return Color.fromRGBO(0, 0, 0, 1);
    } else if (204 <= red && 204 <= green && 204 <= blue) {
      return Color.fromRGBO(255, 255, 255, 1);
    } else if (102 <= red &&
        red <= 153 &&
        102 <= green &&
        green <= 153 &&
        102 <= blue &&
        blue <= 153) {
      return Color.fromRGBO(128, 128, 128, 1);
    } else if (153 <= red && green <= 102 && blue <= 102) {
      if (red <= 204) {
        return Color.fromRGBO(102, 0, 0, 1);
      } else if (green <= 51 && blue <= 51) {
        return Color.fromRGBO(255, 0, 0, 1);
      } else {
        return Color.fromRGBO(255, 153, 153, 1);
      }
    } else if (153 <= red && 102 <= green && green <= 153 && blue <= 102) {
      if (red <= 204 && green <= 102) {
        return Color.fromRGBO(102, 51, 0, 1);
      } else if (green <= 153 && blue <= 51) {
        return Color.fromRGBO(255, 128, 0, 1);
      } else {
        return Color.fromRGBO(255, 204, 153, 1);
      }
    } else if (153 <= red && 153 <= green && blue <= 102) {
      if (red <= 204 && green <= 204) {
        return Color.fromRGBO(102, 102, 0, 1);
      } else if (blue <= 102) {
        return Color.fromRGBO(255, 255, 0, 1);
      } else {
        return Color.fromRGBO(255, 255, 153, 1);
      }
    } else if (red <= 102 && 153 <= green && blue <= 102) {
      return Color.fromRGBO(0, 255, 0, 1);
    } else if (red <= 102 && 153 <= green && 102 <= blue && blue <= 153) {
      return Color.fromRGBO(0, 102, 51, 1);
    } else if (red <= 102 && 153 <= green && 153 <= blue) {
      return Color.fromRGBO(0, 102, 102, 1);
    } else if (red <= 102 && green <= 102 && 153 <= blue) {
      if (blue <= 153) {
        return Color.fromRGBO(0, 0, 102, 1);
      } else {
        return Color.fromRGBO(0, 0, 255, 1);
      }
    } else if (153 <= red && green <= 102 && 153 <= blue) {
      if (red <= 153 && blue <= 153) {
        return Color.fromRGBO(102, 0, 102, 1);
      } else {
        return Color.fromRGBO(255, 0, 255, 1);
      }
    } else if (153 <= red && green <= 102 && 102 <= blue && blue <= 153) {
      if (red <= 153 && blue <= 76) {
        return Color.fromRGBO(102, 0, 51, 1);
      } else {
        return Color.fromRGBO(255, 0, 128, 1);
      }
    }
  }
}
