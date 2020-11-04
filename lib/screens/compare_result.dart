import 'package:flutter/material.dart';
import 'package:solid_test/logic/compare.dart';

class CompareResultScreen extends StatefulWidget {
  final int imgIdCorrect;
  final String imgPathCorrect;
  final int imgIdWrong;
  final String imgPathWrong;

  const CompareResultScreen({
    this.imgIdCorrect,
    this.imgPathCorrect,
    this.imgIdWrong,
    this.imgPathWrong,
  });

  @override
  _CompareResultScreenState createState() => _CompareResultScreenState();
}

class _CompareResultScreenState extends State<CompareResultScreen> {
  bool isCompare = false;
  Compare compare = Compare();
  Image correctImg;
  Image wrongImg;
  GlobalKey _rowKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    correctImg = Image.asset(widget.imgPathCorrect);
    wrongImg = Image.asset(widget.imgPathWrong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare result'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.white,
          child: Column(children: <Widget>[
            Row(key: _rowKey, children: <Widget>[
              Expanded(
                child: buildImgCard(widget.imgPathCorrect),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: buildImgCard(widget.imgPathWrong),
              ),
            ]),
            isCompare ? buildDiffColorsList() : SizedBox(),
          ]),
        ),
      ),
      floatingActionButton: Container(
        height: 55.0,
        child: RawMaterialButton(
          fillColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(55.0),
          ),
          onPressed: () {
            compare.clearColorsDiffLists();
            setState(() {
              isCompare = true;
            });
          },
          child: Text(
            'Сравнить',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Column buildDiffColorsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Правильно',
                style: TextStyle(fontSize: 24.0),
              ),
              Text(
                'Неправильно',
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: compare.replaceImg(
              widget.imgPathCorrect, widget.imgIdCorrect, widget.imgPathWrong),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return Container(
                  height: 76.0 * compare.fColors.length,
                  child: ListView.builder(
                    itemCount: compare.fColors.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildDiffColorContainer(compare.fColors[index]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildDiffColorContainer(compare.sColors[index]),
                          ),
                        ],
                      );
                    },
                  ),
                );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Container buildDiffColorContainer(Color color) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      width: 50.0,
      height: 50.0,
    );
  }

  Card buildImgCard(String path) => Card(child: Image.asset(path));
}
