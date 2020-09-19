import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

var data;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Laravel 8",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    showSearch(context: context, delegate: DataSearch()))
          ],
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: ExpansionTile(
                  // leading: Icon(Icons.arrow_forward_ios),
                  title: Text(data[index]['titulo']),
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: Icon(Icons.arrow_forward_ios),
                            title: Text(data[index]['items'][i]['titulo']),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Detail(
                                          supertitle: data[index]['titulo'],
                                          title: data[index]['items'][i]
                                              ['titulo'],
                                          content: data[index]['items'][i]
                                              ['contenido'])));
                            },
                          );
                        },
                        itemCount: data[index]['items'].length)
                  ],
                ),
              );
            },
            itemCount: data.length));
  }
}

class Detail extends StatelessWidget {
  final String supertitle;
  final String title;
  final String content;

  const Detail({Key key, this.title, this.content, this.supertitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supertitle),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: HtmlWidget(content),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
          )
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

}

