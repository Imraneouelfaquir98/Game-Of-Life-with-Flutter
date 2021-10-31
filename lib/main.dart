import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cellular Automata Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cellular Automata Simulation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int width = 100, hight = 55;
  List<List<int>> celluls = List<List<int>>.generate(55, (index) => List<int>.generate(100, (index) => new Random().nextInt(2)));

  @override
  void initState() {
    /*
    celluls[0][80] = 1;
    celluls[0][82] = 1;
    celluls[1][82] = 1;
    celluls[2][84] = 1;
    celluls[3][84] = 1;
    celluls[4][84] = 1;
    celluls[3][86] = 1;
    celluls[4][86] = 1;
    celluls[5][86] = 1;
    celluls[4][87] = 1;
     */
    _timer();
  }

  void _timer() {
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      setState(() {
        update();
        _timer();
      });
    });
  }

  void update(){
    List<List<int>> new_celluls = List<List<int>>.generate(hight, (index) => List<int>.generate(width, (index) => 0));
    int nbr_neighbors = 0;
    for(int i=0; i<hight; i++){
      for(int j=0; j<width; j++){
        nbr_neighbors = count_neighbors(i, j);
        if(celluls[i][j] == 1){
          if(nbr_neighbors<2 || nbr_neighbors>3)
            new_celluls[i][j] = 0;
          if(nbr_neighbors == 2 || nbr_neighbors == 3)
            new_celluls[i][j] = 1;
        }
        else if(celluls[i][j] == 0 && nbr_neighbors == 3)
          new_celluls[i][j] = 1;
      }
    }
    celluls = new_celluls;
  }

  int count_neighbors(int x, int y){
    int nbr = 0;
    for(int i=x-((x>0)?1:0); i<=x+((x<hight-1)?1:0); i++){
      for (int j = y-((y>0)?1:0); j<=y+((y<width-1)?1:0); j++){
        if( celluls[i][j] == 1 && (i!=x || j!=y))
          nbr++;
      }
    }
    return nbr;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: GridView.builder(
          padding: EdgeInsets.all(2),
          itemCount: 5500,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 100,
            mainAxisSpacing: 0.0,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.only(left:10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: celluls[index~/100][index%100] == 1 ?Colors.grey[900]:Colors.white,
              border: Border.all(color: Colors.black),
              boxShadow: [
                BoxShadow(
                  color: celluls[index~/100][index%100] == 1 ? Colors.grey.withOpacity(0.5) : Colors.white,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Text('.'),
          ),
        ),
      )
    );
  }
}
