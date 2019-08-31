import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  _MyHomePageState() {
    this.response = new List();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _retrieveData(String text) async {
    if (text != '') {
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
  }

  void _setResults(response) {
    List<Widget> result = new List();

    for (var item in response) {
      result.add(
        Container( child:
        Image.network(
          item['artworkUrl100'].toString().replaceAll('100x100', '300x300'),)));
    }

    this.result = result;
  }

  Widget _getItems(BuildContext buildContext, int index) {
    return this.result[index];
  }

  void _setText(String text) {
    this._retrieveData(text);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: ListView.builder(
                    shrinkWrap: false,
                    
                    itemBuilder: this._getItems,
                    itemCount: this._size)),
            TextField(
              decoration: InputDecoration(hintText: 'Say HI'),
              onChanged: this._setText,
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
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
