import 'package:flutter/material.dart';
import 'package:solid_test/models/img.dart';
import 'package:solid_test/screens/compare_result.dart';
import 'package:solid_test/widgets/image_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final List<String> imgPathList = [
  'assets/wb/cactus0.jpeg',
  'assets/wb/cat0.jpeg',
  'assets/wb/crab0.jpeg',
  'assets/wb/ocelot0.jpeg',
  'assets/wb/pikachu0.jpeg'
];
final List<String> imgCorrectPathList = [
  'assets/correct/cactus1.jpeg',
  'assets/correct/cat1.jpeg',
  'assets/correct/crab1.jpeg',
  'assets/correct/ocelot1.jpeg',
  'assets/correct/pikachu1.jpeg'
];
final List<String> imgWrongPathList = [
  'assets/wrong/cactus2.jpeg',
  'assets/wrong/cat2.jpeg',
  'assets/wrong/crab2.jpeg',
  'assets/wrong/ocelot2.jpeg',
  'assets/wrong/pikachu2.jpeg'
];

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> imgWidgetList = List<Widget>();
  List<Img> imgs = List<Img>();
  List<Img> imgsCorrect = List<Img>();
  List<Img> imgsWrong = List<Img>();

  @override
  void initState() {
    super.initState();
    createImgsList(imgPathList, imgs);
    createImgsList(imgCorrectPathList, imgsCorrect);
    createImgsList(imgWrongPathList, imgsWrong);
    getBuildImgList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Compare Img'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10.0,
            spacing: 10.0,
            children: imgWidgetList,
          ),
        ),
      ),
    );
  }

  void createImgsList(List<String> path, List<Img> imgsList) {
    for (int i = 0; i < path.length; i++) {
      imgsList.add(Img(id: i, imgPath: path[i]));
    }
  }

  void getBuildImgList() {
    for (int i = 0; i < imgs.length; i++) {
      imgWidgetList.add(
        ImageContainer(
          imgId: imgs[i].id,
          imgPath: imgs[i].imgPath,
          onTap: navigateToCompareResult,
        ),
      );
    }
  }

  void navigateToCompareResult(int imgId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompareResultScreen(
          imgIdCorrect: imgsCorrect[imgId].id,
          imgPathCorrect: imgsCorrect[imgId].imgPath,
          imgIdWrong: imgsWrong[imgId].id,
          imgPathWrong: imgsWrong[imgId].imgPath,
        ),
      ),
    );
  }
}
