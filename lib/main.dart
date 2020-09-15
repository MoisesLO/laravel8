import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    title: "Laravel 8",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;

  Future loadJson() async {
    String data = await rootBundle.loadString('assets/json/data.json');
    return json.decode(data);
  }

  @override
  void initState() {
    loadJson().then((value) {
      setState(() {
        data = value;
      });
    });
    super.initState();
    // print(data[1]['titulo']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Laravel 8'),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(data[index]['titulo']),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(
                            title: Text(data[index]['items'][i]['titulo']));
                      },
                      itemCount: data[index]['items'].length)
                ],
              );
            },
            itemCount: data.length));
  }
}
