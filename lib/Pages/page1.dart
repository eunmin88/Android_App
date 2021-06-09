import 'package:flutter/material.dart';
import 'package:pa3_2018315083/Pages/page2.dart';

String _id;
class page1 extends StatelessWidget {
  final Map<String, String> arguments;
  page1(this.arguments);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute:(routerSettings){
        switch(routerSettings.name){
          case '/':
            _id = arguments['user-msg1'];
            return MaterialPageRoute(builder: (_) => page11());
          case '/page2':
            return MaterialPageRoute(builder: (_) => page2(routerSettings.arguments));
          default:
            _id = arguments['user-msg1'];
            return MaterialPageRoute(builder: (_) => page11());
        }
      },
    );
  }
}
class page11 extends StatelessWidget {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String _imagepath = "assets/images/corona.png";
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('2018315083 Eunmin Kim'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'CORONA LIVE',
              style: TextStyle(fontSize: 25, color: Colors.blueGrey),
            ),
            Text(
              'Login Success. Hello ' + _id +  '!!',
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            new Container(
              width: 150,
              height: 100,
            ),
            SizedBox(
              width: 300,
              height: 200,
              child:  Image.asset(_imagepath),
            ),
              Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [

                    Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:170,
                            child:
                            ElevatedButton(onPressed:(){
                              Navigator.pushNamed(
                                context,
                                '/page2',
                                arguments:{"user-msg1": (_id), "user-msg2": 'Login Page',},
                              );
                            }, child: Text("Start CORONA LIVE")),
                          ),
                        ]
                    ),
                  ]
              ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
