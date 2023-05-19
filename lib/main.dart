import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

var time_connection_start = DateTime.now().millisecond;
DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
void main() async {


  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => const HomePage(), routes: [
      GoRoute(
        path: "server1",
        builder: (context, state) => const Serv1(),
      ),
      GoRoute(
        path: "server2",
        builder: (context, state) => const Serv2(),
      )
    ]),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String _title = 'Ksenia        Choice server';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),

      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [

          SizedBox(
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 30),
                  backgroundColor: Colors.blueAccent),
              onPressed: () => context.go("/server1"),
              child: const Text('Connect to server 1'),
            ),
          ),
          SizedBox(
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 30),
                  backgroundColor: Colors.blueAccent),
              onPressed: () => context.go("/server2"),
              child: const Text('Connect to server 2'),
            ),
          ),
        ],
      ),
    );
  }
}

class Serv1 extends StatefulWidget {
  const Serv1({super.key});

  @override
  State<Serv1> createState() => _Serv1State();
}

class _Serv1State extends State<Serv1> {
  TextEditingController myInput = TextEditingController();
  void clearText() {
    myInput.clear();
    }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to server 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Colors.blueAccent),
                onPressed: () => timeWorkingServer((time_connection_start).toString()),
                child: const Text('Working time'),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Colors.blueAccent),
                onPressed: () => windowSize(window.physicalSize.toString()) ,
                child: const Text('Window size'),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white54,
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Colors.blueAccent),

                onPressed: () => clearText(),
                child: const Text('Clear'),
              ),
            ),
            SizedBox(
              height: 150,
              child: TextFormField(

                decoration:const  InputDecoration(

                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                minLines: 5,
                maxLines: 10,
                controller: myInput,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> timeWorkingServer(String msg) async {
    // time_connection_start = time_connection_start+DateTime.now().millisecond;
    Socket socket = await Socket.connect("localhost", 4563);
    myInput.text += "\n${dateFormat.format(DateTime.now())} Client => I want to get working time\n";
    socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        myInput.text += "\n${dateFormat.format(DateTime.now())} Server => $serverResponse \n";
      },
      onError: (error) {
        socket.destroy();
      },
      onDone: () {
        socket.destroy();
      },
    );
    socket.write(time_connection_start);

    await Future.delayed(const Duration(seconds: 5));
    print(socket.address);
    socket.close();
  }

  Future<void> windowSize(String msg) async {
    Socket socket = await Socket.connect("localhost", 4563);
    myInput.text += "\n${dateFormat.format(DateTime.now())} Client => I want to get window size\n";
    msg = "Size";
    socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        myInput.text += "\n${dateFormat.format(DateTime.now())} Server => $serverResponse \n";
      },
      onError: (error) {
        socket.destroy();
      },
      onDone: () {
        socket.destroy();
      },
    );
    socket.write(msg);
    await Future.delayed(const Duration(seconds: 5));
    print(socket.address);
    socket.close();
  }

}





class Serv2 extends StatefulWidget {
  const Serv2({super.key});

  @override
  State<Serv2> createState() => _Serv2State();
}
String screen_weight = "3840";
String screen_height = "2160";
class _Serv2State extends State<Serv2> {


  TextEditingController myInput = TextEditingController();

  void clearText() {
    myInput.clear();
  }


  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to server 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Colors.blueAccent),
                onPressed: () => serverResponse("pid"),
                child: const Text('PID'),
              ),

            ),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 25),
                    backgroundColor: Colors.blueAccent),

                onPressed: () => ScreenRes(MediaQueryData.fromWindow(window).toString()) ,
                child: const Text('Screen resolution'),
              ),

            ),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white54,
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: Colors.blueAccent),

                onPressed: () => clearText(),
                child: const Text('Clear'),
              ),
            ),
            SizedBox(
              height: 150,
              child: TextFormField(

                decoration:const  InputDecoration(

                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                minLines: 5,
                maxLines: 10,
                controller: myInput,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> serverResponse(String msg) async {
    Socket socket = await Socket.connect("localhost", 4571);


    myInput.text += "\n${dateFormat.format(DateTime.now())} Client => I want to get PID\n";
    socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);

        myInput.text += "\n${dateFormat.format(DateTime.now())} Server => $serverResponse \n";

      },
      onError: (error) {
        socket.destroy();
      },
      onDone: () {
        socket.destroy();
      },
    );
    socket.write(msg);

    await Future.delayed(const Duration(seconds: 5));
    print(socket.address);
    socket.close();
  }

  Future<void> ScreenRes(String msg) async {

    Socket socket = await Socket.connect("localhost", 4571);

    msg = "($screen_weight, $screen_height)";
    myInput.text += "\n${dateFormat.format(DateTime.now())} Client => I want to get screen resolution\n";
    socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);

        myInput.text += "\n${dateFormat.format(DateTime.now())} Server => $serverResponse \n";
      },
      onError: (error) {
        socket.destroy();
      },
      onDone: () {
        socket.destroy();
      },
    );
    socket.write(msg);

    await Future.delayed(const Duration(seconds: 5));
    print(socket.address);
    socket.close();
  }

  // Future<void> timeWorkingServer(String msg) async {
  //   time_connection_start = time_connection_start+DateTime.now().millisecond;
  //   Socket socket = await Socket.connect("localhost", 4571);
  //   myInput.text += "\n${DateTime.now()} Client => I want to get working time\n";
  //   socket.listen(
  //         (Uint8List data) {
  //       final serverResponse = String.fromCharCodes(data);
  //
  //
  //       myInput.text += "\n${DateTime.now()} Server => $serverResponse \n";
  //     },
  //     onError: (error) {
  //       socket.destroy();
  //     },
  //     onDone: () {
  //       socket.destroy();
  //     },
  //   );
  //   socket.write(time_connection_start);
  //
  //   await Future.delayed(const Duration(seconds: 5));
  //   print(socket.address);
  //   socket.close();
  // }


}

