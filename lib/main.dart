import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

var data;

Future loadJson() async {
  String data = await rootBundle.loadString('assets/json/data.json');
  return json.decode(data);
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Laravel 8",
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        body: FutureBuilder(
          future: loadJson(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Text('Cargando ...');
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xf5495FF),
                          child: CircleAvatar(
                            radius: 23,
                            backgroundImage: AssetImage('assets/img/logo.png'),
                          ),
                        ),
                        title: Text(snapshot.data[index]['titulo']),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  leading: Icon(Icons.arrow_forward_ios),
                                  title: Text(snapshot.data[index]['items'][i]
                                      ['titulo']),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail(
                                                supertitle: snapshot.data[index]
                                                ['items'][i]['titulo'],
                                                title: snapshot.data[index]
                                                    ['items'][i]['titulo'],
                                                content: snapshot.data[index]
                                                        ['items'][i]
                                                    ['contenido'])));
                                  },
                                );
                              },
                              itemCount: snapshot.data[index]['items'].length)
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data.length);
            }
          },
        ));
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
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.focusColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('build Result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var temporal = new List();
    var temp = new List();
    for (int i = 0; i < data.length; i++) {
      for (int h = 0; h < data[i]['items'].length; h++) {
        // temporal.insert(i,data[i]['items'][h]['titulo']);
        temporal.add(data[i]['items'][h]);
        // print(data[i]['items'][h]['titulo']);
      }
    }

    temp = temporal
        .where((note) => note['contenido'].toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xf5495FF),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: AssetImage('assets/img/logo.png'),
              ),
            ),
            title: Text(temp[index]['titulo']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail(
                          supertitle: temp[index]['titulo'],
                          title: temp[index]['titulo'],
                          content: temp[index]['contenido'])));
            },
          ),
        );
      },
      itemCount: temp.length,
    );
  }
}
