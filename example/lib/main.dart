import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mldsa/flutter_mldsa.dart';
import 'package:pointycastle/api.dart';

void main() async {
  await FlutterMldsa.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter  Mldsa',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Flutter Mldsa'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _mldsaResult = false;

  void _mldsa44() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _mldsaResult = testMldsa(mode: MldsaMode.mldsa44);
    });
  }

  void _mldsa65() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _mldsaResult = testMldsa(mode: MldsaMode.mldsa65);
    });
  }

  void _mldsa87() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _mldsaResult = testMldsa(mode: MldsaMode.mldsa87);
    });
  }

  void _reset() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _mldsaResult = false;
    });
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _mldsaResult.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _mldsa44,
            tooltip: 'Increment',
            child: const Icon(Icons.fork_left),
          ),
          FloatingActionButton(
            onPressed: _mldsa65,
            tooltip: 'Increment',
            child: const Icon(Icons.update_rounded),
          ),
          FloatingActionButton(
            onPressed: _mldsa87,
            tooltip: 'Increment',
            child: const Icon(Icons.fork_right),
          ),
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Increment',
            child: const Icon(Icons.restore),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

bool testMldsa({required MldsaMode mode}) {
  final message = utf8.encode('randomtext');
  final keyGenerator = MlDsaKeyGenerator();
  final generatorParams = MlDsaKeyGeneratorParams(mlDsaMode: mode);
  keyGenerator.init(generatorParams);

  final keypairA = keyGenerator.generateKeyPair();
  final signer = MlDsaSigner();
  signer.init(true, PrivateKeyParameter<MlDsaPrivateKey>(keypairA.privateKey));

  final verifier = MlDsaSigner();
  verifier.init(false, PublicKeyParameter<MlDsaPublicKey>(keypairA.publicKey));

  final signature = signer.generateSignature(message);
  return verifier.verifySignature(message, signature);
}
