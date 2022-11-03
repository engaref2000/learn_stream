import 'dart:async';
import 'dart:math' as math show Random;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Cake {}

class Order {
  final String type;
  Order(this.type);
}

extension RandomItem<T> on Iterable<T> {
  T random() => elementAt(math.Random().nextInt(length));
}

const list = ['chocolate', 'banna', 'vinella'];
void testit() {
  final controller = StreamController();
  int number = 0;

  Timer.periodic(const Duration(seconds: 2), (timer) {
    number++;
    final orderType = list.random();
    print('make new order $orderType');
    controller.sink.add(Order(orderType));
    if (number > 5) {
      timer.cancel();
    }
  });

  final baker = StreamTransformer.fromHandlers(handleData: (data, sink) {
    if (data == 'chocolate') {
      sink.add(Cake());
    } else {
      sink.addError('i cant bake this type of cake ');
    }
  });

  controller.stream.map((order) => order.type).transform(baker).listen(
        (event) => print('here is the cake $event'),
        onError: (err) => print(err),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testit();
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
    );
  }
}
