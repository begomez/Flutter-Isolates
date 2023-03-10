// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

/*
 * Main app
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*
 * Binded state object
 */
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _data = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _notUsingAwait,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //XXX: 1
  Future<void> _usingSleep() async {
    var data = _data + "Started $_counter: ${DateTime.now().toString()}\n";
    print(data);

    //XXX: blocks main isolate!!!
    sleep(Duration(seconds: 2));

    data += "End $_counter: ${DateTime.now().toString()}\n";
    print(data);

    setState(() {
      _counter += 1;
      _data = data;
    });
  }

  //XXX: 2
  Future<void> _notUsingAwait() async {
    var data = _data + "Started $_counter: ${DateTime.now().toString()}\n";
    print(data);

    //XXX: this line "does nothing", we are not awaiting
    Future.delayed(Duration(seconds: 2));

    data += "End $_counter: ${DateTime.now().toString()}\n";
    print(data);

    setState(() {
      _counter += 1;
      _data = data;
    });
  }

  //XXX: 3
  Future<void> _usingAwait() async {
    var data = _data + "Started $_counter: ${DateTime.now().toString()}\n";
    print(data);

    //XXX: we're awaiting so it allows concurrency
    await Future.delayed(Duration(seconds: 2));

    data += "End $_counter: ${DateTime.now().toString()}\n";
    print(data);

    setState(() {
      _counter += 1;
      _data = data;
    });
  }
}
