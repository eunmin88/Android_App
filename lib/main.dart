import 'package:flutter/material.dart';
import 'package:pa3_2018315083/Pages/page1.dart';
import 'package:pa3_2018315083/Pages/page2.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
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
                return MaterialPageRoute(builder: (_) => MyHomePage());
              case '/page1':
                return MaterialPageRoute(builder: (_) => page1(routerSettings.arguments));
              default:
                return MaterialPageRoute(builder: (_) => MyHomePage());
            }
          },
        );
  }
}

class MyHomePage extends StatelessWidget {
  //final textController = TextEditingController();
  //final textController2 = TextEditingController();
  String _id = "temp";
  String _pass = "temp";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

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
              'Login Please...',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            new Container(
              width: 150,
              height: 50,
            ),
            new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                        Text("ID: "),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            //controller: textController,
                            onChanged:(text){
                              _id = text;
                            }
                          ),
                        ),
                      ]
                    ),

                  Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text("PW: "),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          //controller: textController2,
                            onChanged:(text){
                              _pass = text;
                            }
                        ),
                      ),
                    ]
                  ),
                    Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:100,
                            child:
                            ElevatedButton(
                                onPressed:(){
                                  if(_id == 'skku' && _pass == '1234'){
                                    Navigator.pushNamed(
                                      context,
                                      '/page1',
                                      arguments:{"user-msg1": _id,},
                                    );
                                  }
                                },
                                child: Text("Login")),
                          ),
                        ]
                    ),
                        ]
              ),
            ),
          ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  }
