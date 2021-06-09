import 'package:flutter/material.dart';
import 'package:pa3_2018315083/Pages/page2.dart';
import 'package:pa3_2018315083/Pages/page4.dart';
import 'package:pa3_2018315083/Pages/page3.dart';
String _id;
String prev;
class page2 extends StatelessWidget {
  final Map<String, String> arguments;
  page2(this.arguments);
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
            prev = arguments['user-msg2'];
            return MaterialPageRoute(builder: (_) => page22());
          case '/page3':
            return MaterialPageRoute(builder: (_) => page4(routerSettings.arguments));
          case '/page4':
            return MaterialPageRoute(builder: (_) => page3(routerSettings.arguments));
          default:
            _id = arguments['user-msg1'];
            prev = arguments['user-msg2'];
            return MaterialPageRoute(builder: (_) => page22());
        }
      },
    );
  }
}
class page22 extends StatelessWidget {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  List<String> _data = ['Cases/Deaths', 'Vaccine',];
  List<bool> boolList = [true, false];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Menu'),
      ),
      body:  Column(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 500,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _data.length,
                  itemBuilder: (BuildContext _ctx, int i){
                    return ListTile(
                      title: Text(_data[i],
                          style: TextStyle(fontSize:23,)
                      ),
                      leading: boolList[i]
                          ? Icon(Icons.coronavirus_outlined)
                          : Icon(Icons.local_hospital),
                      onTap: (){
                        if(boolList[i] == true){
                          Navigator.pushNamed(
                            context,
                            '/page3',
                            arguments:{"user-msg1": (_id),},
                          );
                        }
                       else{
                          Navigator.pushNamed(
                            context,
                            '/page4',
                            arguments:{"user-msg1": (_id),},
                          );
                        }
                    }
                    );
                  }
              ),
            ),

            SizedBox(
              width: 200,
              height: 300,
            ),
          Center(
            child: Text(
              'Welcome! ' + _id,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
            Center(
              child: Text(
                'Previous: ' + prev,
                style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
            ),
        ],
        )
    );
  // This trailing comma makes auto-formatting nicer for build methods.
  }
}
