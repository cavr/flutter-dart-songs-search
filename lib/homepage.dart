import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/debouncer.dart';
import 'package:my_app/drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _text = "";
  List response;
  int _size = 0;
  List<Widget> result;
  final _debouncer = Debouncer(milliseconds: 5000);

  _MyHomePageState() {
    this.response = new List();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _retrieveData(String text) async {
    print('Retieving Data');
      if(text == ''){
        text = 'random';
      }
      final response = await http.get(
          "https://itunes.apple.com/search?term=${text}&entity=musicTrack");
      try {
        final jsonResponse = json.decode(response.body);
        this.response = jsonResponse['results'];
        this._setResults(jsonResponse['results']);
        setState(() {
          this._size = jsonResponse['results'].length;
        });
      } catch (e) {
        this.response = new List();
      }
      setState(() {});

  }

  void _setResults(List response) {
    List<Widget> result = new List();

    response.removeWhere((item) =>
        response
            .where((inner) => inner['collectionId'] == item['collectionId'])
            .first !=
        item);

    for (var item in response) {
      result.add(Container(
          child: GestureDetector(
              onTap: this._onTap,
              child: Image.network(item['artworkUrl100']
                  .toString()
                  .replaceAll('100x100', '300x300')))));
    }

    this.result = result;
  }

  void _onTap() {
    setState(() {
      this._counter = 9999;
    });
  }

  Widget _getItems(BuildContext buildContext, int index) {
    return this.result[index];
  }

  void _setText(String text) {
    _debouncer.run(() => this._retrieveData(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: drawer(),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Search', contentPadding: EdgeInsets.all(16)),
                  onChanged: this._setText,
                ),
                width: 400,
                padding: EdgeInsets.all(16)),
            new Expanded(
                child: ListView.builder(
                    shrinkWrap: false,
                    itemBuilder: this._getItems,
                    itemCount: this._size)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
