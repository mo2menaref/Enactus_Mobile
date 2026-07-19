import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("hello"),
          Text("Andrew and Bishoydddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"),
          Padding(
         padding: EdgeInsetsGeometry.all(20),
         child: Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
          SizedBox(height: 20,),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
        ],
      ),
    ) ;
  }
}
