import 'package:flutter/material.dart';
import 'package:pa3_2018315083/Pages/page2.dart';
import 'package:pa3_2018315083/Pages/page4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';

String _id;
String cur;
List<dynamic> graph;
Future<AlbumList> fetchAlbum() async {
  String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json";
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return AlbumList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class AlbumList {
  final List<Album> lists;

  AlbumList({
    this.lists,
  });

  factory AlbumList.fromJson(List<dynamic> parsedJson) {

    List<Album> lists2 = new List<Album>();
    lists2 = parsedJson.map((i)=>Album.fromJson(i)).toList();

    return new AlbumList(
        lists: lists2
    );
  }
}
class Album {
  final String country;
  final String iso_code;
  final List<dynamic> data;
  Album({@required this.data, @required this.country, @required this.iso_code});
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      country: json["country"],
      iso_code: json['iso_code'],
      data: json['data'],
    );
  }
}


class page3 extends StatelessWidget {
  final Map<String, String> arguments;
  page3(this.arguments);
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
            return MaterialPageRoute(builder: (_) => page32());
          case '/page2':
            _id = arguments['user-msg1'];
            return MaterialPageRoute(builder: (_) => page2(routerSettings.arguments));
          default:
            _id = arguments['user-msg1'];
            return MaterialPageRoute(builder: (_) => page32());
        }
      },
    );
  }
}





class page32 extends StatelessWidget {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  List<String> _data = ['Cases/Deaths', 'Vaccine',];
  List<bool> boolList = [true, false];
  Future<AlbumList> futureAlbum = fetchAlbum();
  List<FlSpot> spots = [FlSpot(1, 1)];
  List<String> dates = ['0'];
  List<double> total = [0, 0, 0, 0, 0, 0, 0];
  int type = 0;
  double min = 0;
  double max = 0;
  bool check = false;
  List<String> table = [];
  List<int> totalvacc = [];
  List<int> fullyvacc = [];
  List<int> dailyvacc = [];
  Map<String, List<int>> multi = new Map<String, List<int>>();

  Widget buildTable(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: table.length,
      itemBuilder: (context, idx) => Text(table[idx]),
    );
  }


  Widget _buildGraph(){
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled:false),
        lineBarsData: [
          LineChartBarData(
            colors: [Colors.blue],
            isCurved: true,
            spots: spots,
            dotData: FlDotData(
              show:true,
            ),
            barWidth: 5,
            isStrokeCapRound: true,
          ),
        ],
        minY: min,
        maxY: max,

        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
              showTitles: true,
              getTitles:(value){
                if(type == 1 && value %7 != 0 && value !=27){
                  return '';
                }
                else if(type==0 && value < 7)
                  return dates[value.toInt()].substring(5,10);

                else if(type == 1 && value < 28)
                  return dates[value.toInt()].substring(5,10);
                else
                  return '';
              }
          ),

        ),
      ),

    );
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(

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
          Center(
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: Row(
                children:[
                  Column(
                      children:[
                        FutureBuilder<AlbumList>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              graph = snapshot.data.lists;
                              int i;
                              for(i =0; i < graph.length; i++){
                                if(graph[i].country == "South Korea"){
                                  break;
                                }
                              }
                              List<dynamic> temp = snapshot.data.lists[i].data;
                              String last = temp.last['date'];
                              cur = last;

                              return Container();
                            } else if (snapshot.hasError) {
                              return Container();
                            }
                            return Container();
                          },
                        ),
                        Text('Total Vacc.'),
                        FutureBuilder<AlbumList>(

                          future: futureAlbum,
                          builder: (context, snapshot) {
                            int total = 0;
                            if (snapshot.hasData && cur != null) {
                              List<dynamic> temp = snapshot.data.lists;
                              for(int i = 0; i < temp.length; i++){
                                bool k = false;
                                List<dynamic> temp2 = temp[i].data;
                                List<int> kkk = [];
                            if(multi[graph[i].country] != null){
                                  kkk = multi[graph[i].country];
                                }


                                for(int j = 1; j < temp2.length;j++){
                                  String one = cur;
                                  String two= temp2[j]['date'].toString();

                                  one = one.substring(0, 4) + one.substring(5, 7) + one.substring(8, 10);
                                  two = two.substring(0, 4) + two.substring(5, 7) + two.substring(8, 10);


                                  if(one.contains(two)){
                                    if(temp2[j]['total_vaccinations'] != null){
                                      total = total + temp2[j]['total_vaccinations'];
                                      if(totalvacc.length < graph.length){
                                        totalvacc.add(temp2[j]['total_vaccinations']);
                                        kkk.add(temp2[j]['total_vaccinations']);
                                      }
                                    }
                                    else if(temp2[j]['people_vaccinated'] != null){
                                      total = total + temp2[j]['people_vaccinated'];
                                      if(totalvacc.length < graph.length){
                                        totalvacc.add(temp2[j]['people_vaccinations']);
                                        kkk.add(temp2[j]['people_vaccinations']);
                                      }

                                    }
                                    else if(temp2[j]['people_fully_vaccinated'] != null){
                                      total = total + temp2[j]['people_fully_vaccinated'];
                                      if(totalvacc.length < graph.length){
                                        totalvacc.add(temp2[j]['people_fully_vaccinations']);
                                        kkk.add(temp2[j]['people_fully_vaccinations']);
                                      }
                                    }
                                    else{
                                      if(totalvacc.length <= graph.length){
                                        totalvacc.add(null);
                                        kkk.add(null);
                                      }

                                    }
                                    k = true;
                                  }
                                }
                                if(k == false){
                                  if(temp2[temp2.length - 1]['total_vaccinations'] != null){
                                    total = total + temp2[temp2.length - 1]['total_vaccinations'];
                                    if(totalvacc.length < graph.length){
                                      totalvacc.add(temp2[temp2.length - 1]['total_vaccinations']);
                                      kkk.add(temp2[temp2.length - 1]['total_vaccinations']);
                                    }

                                  }
                                  else if(temp2[temp2.length - 1]['people_vaccinated'] != null){
                                    total = total + temp2[temp2.length - 1]['people_vaccinated'];
                                    if(totalvacc.length < graph.length){
                                      totalvacc.add(temp2[temp2.length - 1]['people_vaccinated']);
                                      kkk.add(temp2[temp2.length - 1]['people_vaccinated']);
                                    }

                                  }
                                  else if(temp2[temp2.length - 1]['people_fully_vaccinated'] != null){
                                    total = total + temp2[temp2.length - 1]['people_fully_vaccinated'];
                                    if(totalvacc.length < graph.length){
                                      totalvacc.add(temp2[temp2.length - 1]['people_fully_vaccinated']);
                                      kkk.add(temp2[temp2.length - 1]['people_fully_vaccinated']);
                                    }

                                  }
                                  else{
                                    if(totalvacc.length < graph.length){
                                      totalvacc.add(null);
                                      kkk.add(null);
                                    }

                                  }
                                }
                                multi.putIfAbsent(graph[i].country, () =>  kkk);
                                multi.update(graph[i].country, (value) => kkk);
                              }
                              return Text(total.toString() + ' people');
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");              }
                            return CircularProgressIndicator();
                          },
                        ),
                        SizedBox(
                          width: 50,
                          height:5,
                        ),
                        Text('Total fully Vacc.'),
                        FutureBuilder<AlbumList>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            int total = 0;
                            if (snapshot.hasData && cur != null) {
                              List<dynamic> temp = snapshot.data.lists;

                              for(int i = 0; i < temp.length; i++){
                                bool k = false;
                                List<dynamic> temp2 = temp[i].data;
                                List<int> kkk = [];
                                if(multi[graph[i].country] != null){
                                  kkk = multi[graph[i].country];
                                }

                                for(int j = 1; j < temp2.length;j++){
                                  String one = cur;
                                  String two= temp2[j]['date'].toString();
                                  one= one.substring(0, 4) + one.substring(5, 7) + one.substring(8, 10);
                                  two = two.substring(0, 4) + two.substring(5, 7) + two.substring(8, 10);
                                  int one1 = int.parse(one);
                                  int two2 = int.parse(two);

                                  if(one.contains(two)){
                                    if(temp2[j]['people_fully_vaccinated'] != null){
                                      total = total + temp2[j]['people_fully_vaccinated'];
                                      if(fullyvacc.length < graph.length){
                                        fullyvacc.add(temp2[j]['people_fully_vaccinated']);
                                        kkk.add(temp2[j]['people_fully_vaccinated']);
                                      }

                                    }
                                    else if(temp2[j-1]['people_fully_vaccinated'] != null){
                                        total = total + temp2[j-1]['people_fully_vaccinated'];
                                        if(fullyvacc.length < graph.length){
                                          fullyvacc.add(temp2[j-1]['people_fully_vaccinated']);
                                          kkk.add(temp2[j-1]['people_fully_vaccinated']);
                                        }

                                      }
                                    else{
                                      if(fullyvacc.length < graph.length){
                                        fullyvacc.add(null);
                                        kkk.add(null);
                                      }

                                  }

                                    k = true;
                                  }
                                }
                                if(k == false){
                                  if(temp2[temp2.length-1]['people_fully_vaccinated'] != null){
                                    total = total + temp2[temp2.length-1]['people_fully_vaccinated'];
                                    if(fullyvacc.length < graph.length){
                                      fullyvacc.add(temp2[temp2.length-1]['people_fully_vaccinated']);
                                      kkk.add(temp2[temp2.length-1]['people_fully_vaccinated']);
                                    }

                                  }
                                  else{
                                    if(fullyvacc.length < graph.length){
                                      fullyvacc.add(null);
                                      kkk.add(null);
                                    }
                                  }
                                }
                                multi.putIfAbsent(graph[i].country, () =>  kkk);
                                multi.update(graph[i].country, (value) => kkk);
                              }
                              return Text(total.toString() + ' people');
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");              }
                            return CircularProgressIndicator();
                          },
                        ),
                      ]
                  ),
                  SizedBox(
                    width: 90,

                  ),
                  Column(
                      children:[
                        Text('Parsed latest date.'),
                        FutureBuilder<AlbumList>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              graph = snapshot.data.lists;
                              int i;
                              for(i =0; i < graph.length; i++){
                                if(graph[i].country == "South Korea"){
                                  break;
                                }
                              }
                              List<dynamic> temp = snapshot.data.lists[i].data;
                              String last = temp.last['date'];
                              cur = last;

                              return Text(last);
                            } else if (snapshot.hasError) {
                              return Container();
                            }
                            return Container();
                          },
                        ),
                        SizedBox(
                          width: 70,
                          height:5,
                        ),
                        Text('Daily Vacc.'),
                        FutureBuilder<AlbumList>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            int total = 0;
                            if (snapshot.hasData && cur != null) {
                              List<dynamic> temp = snapshot.data.lists;

                              for(int i = 0; i < temp.length; i++){
                                bool k = false;
                                List<dynamic> temp2 = temp[i].data;
                                List<int> kkk = [];
                                if(multi[graph[i].country] != null){
                                  kkk = multi[graph[i].country];
                                }

                                for(int j = 1; j < temp2.length;j++){
                                  String one = cur;
                                  String two= temp2[j]['date'].toString();
                                  one= one.substring(0, 4) + one.substring(5, 7) + one.substring(8, 10);
                                  two = two.substring(0, 4) + two.substring(5, 7) + two.substring(8, 10);


                                  if(one.contains(two)){
                                    if(temp2[j]['daily_vaccinations'] != null){
                                      total = total + temp2[j]['daily_vaccinations'];
                                      if(dailyvacc.length < graph.length){
                                        dailyvacc.add(temp2[j]['daily_vaccinations']);
                                        kkk.add(temp2[j]['daily_vaccinations']);
                                      }

                                    }
                                    else if(temp2[j-1]['daily_vaccinations'] != null){
                                        total = total + temp2[j-1]['daily_vaccinations'];
                                        if(dailyvacc.length < graph.length){
                                          dailyvacc.add(temp2[j-1]['daily_vaccinations']);
                                          kkk.add(temp2[j-1]['daily_vaccinations']);
                                        }

                                      }
                                    else{
                                      if(dailyvacc.length < graph.length){
                                        dailyvacc.add(null);
                                        kkk.add(null);
                                      }

                                    }

                                    k = true;
                                  }
                                }
                                if(k == false){
                                  if(temp2[temp2.length-1]['daily_vaccinations'] != null){
                                    total = total + temp2[temp2.length-1]['daily_vaccinations'];
                                    if(dailyvacc.length < graph.length){
                                      dailyvacc.add(temp2[temp2.length-1]['daily_vaccinations']);
                                      kkk.add(temp2[temp2.length-1]['daily_vaccinations']);
                                    }

                                  }
                                  else{
                                    if(dailyvacc.length < graph.length){
                                      dailyvacc.add(null);
                                      kkk.add(null);
                                    }

                                  }
                                }
                                multi.putIfAbsent(graph[i].country, () =>  kkk);
                                multi.update(graph[i].country, (value) => kkk);
                              }
                              return Text(total.toString() + ' people');
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");              }
                            return CircularProgressIndicator();
                          },
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: Column(

                children:[

                  Row(
                    children:[
                      InkWell(
                          child: Text(
                            'Graph1',
                            style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                          ),
                          onTap: () {
                            spots = [];
                            List<String> date = [];
                            dates = [];
                            check = true;
                            min = 8000000000;
                            max = 9500000000;
                            total = [0, 0, 0, 0, 0, 0, 0];
                            bool k = false;
                            type = 0;
                            for(int i = 0; i < graph.length; i++){
                              for(int j = 0; j < graph[i].data.length;j++){
                                if(cur == graph[i].data[j]['date'].toString()){
                                  int x = 0;
                                  while(x < 7){
                                    date.add(graph[i].data[j - x]['date'].toString());
                                    x++;
                                  }
                                  k = true;
                                  break;
                                }
                                if(k == true){
                                  break;
                                }
                              }
                            }
                            int y = 0;
                            while(y < 7){
                              for (int i = 0; i < graph.length; i++) {
                                List<dynamic> temp2 = graph[i].data;

                                for (int j = 0; j < temp2.length; j++) {
                                  String one = date[y];
                                  String two = temp2[j]['date'].toString();
                                  one = one.substring(0, 4) + one.substring(5, 7) +
                                      one.substring(8, 10);
                                  two = two.substring(0, 4) + two.substring(5, 7) +
                                      two.substring(8, 10);
                                  if (one == two) {
                                    if (temp2[j]['total_vaccinations'] != null) {
                                      total[y] = total[y] + temp2[j]['total_vaccinations'];
                                    }
                                    else if(temp2[j]['people_vaccinated'] != null){
                                      total[y] = total[y] + temp2[j]['people_vaccinated'];
                                    }
                                    else if(temp2[j]['people_fully_vaccinated'] != null){
                                      total[y] = total[y] + temp2[j]['people_fully_vaccinated'];
                                    }
                                  }
                                }

                              }
                              y++;
                            }
                            for(int i = date.length - 1; i >= 0;i--){
                              dates.add(date[i]);

                            }
                            double ss = 0;
                            for(int a = 6; a >=0; a--){
                              spots.add(FlSpot(ss, total[a]));
                              ss++;
                            }
                            (context as Element).markNeedsBuild();
                          }
                      ),
                      SizedBox(
                        width:40,
                      ),
                      InkWell(
                          child: Text(
                            'Graph2',
                            style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                          ),
                          onTap: () {
                            spots = [];
                            dates = [];
                            min = 120000000;
                            max = 150000000;
                            check = true;
                            List<String> date = [];
                            total = [0, 0, 0, 0, 0, 0, 0];
                            bool k = false;
                            type = 0;
                            for(int i = 0; i < graph.length; i++){
                              for(int j = 0; j < graph[i].data.length;j++){
                                if(cur == graph[i].data[j]['date'].toString()){
                                  int x = 0;
                                  while(x < 7){
                                    date.add(graph[i].data[j - x]['date'].toString());
                                    x++;
                                  }
                                  k = true;
                                  break;
                                }
                                if(k == true){
                                  break;
                                }
                              }
                            }
                            int y = 0;
                            while(y < 7){
                              for (int i = 0; i < graph.length; i++) {
                                List<dynamic> temp2 = graph[i].data;

                                for (int j = 0; j < temp2.length; j++) {
                                  String one = date[y];
                                  String two = temp2[j]['date'].toString();
                                  one = one.substring(0, 4) + one.substring(5, 7) +
                                      one.substring(8, 10);
                                  two = two.substring(0, 4) + two.substring(5, 7) +
                                      two.substring(8, 10);
                                  if (one.contains(two)) {
                                    if (temp2[j]['daily_vaccinations'] != null) {
                                      total[y] = total[y] + temp2[j]['daily_vaccinations'];
                                    }
                                  }
                                }
                              }
                              y++;
                            }
                            for(int i = date.length - 1; i >= 0;i--){
                              dates.add(date[i]);
                            }
                            double ss = 0;
                            for(int a = 6; a >=0; a--){
                              spots.add(FlSpot(ss, total[a]));
                              ss++;
                            }
                            (context as Element).markNeedsBuild();
                          }
                      ),
                      SizedBox(
                        width:40,
                      ),
                      InkWell(
                        child: Text(
                          'Graph3',
                          style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                        ),
                        onTap: () {
                          spots = [];
                          dates = [];
                          min = 5000000000;
                          max = 9000000000;
                          check = true;
                          List<String> date = [];
                          total = [0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0];
                          bool k = false;
                          type = 1;
                          for(int i = 0; i < graph.length; i++){
                            for(int j = 0; j < graph[i].data.length;j++){
                              if(cur == graph[i].data[j]['date'].toString()){
                                int x = 0;
                                while(x < 28){
                                  date.add(graph[i].data[j - x]['date'].toString());
                                  x++;
                                }
                                k = true;
                                break;
                              }
                              if(k == true){
                                break;
                              }
                            }
                          }
                          int y = 0;
                          while(y < 28){
                            for (int i = 0; i < graph.length; i++) {
                              List<dynamic> temp2 = graph[i].data;

                              for (int j = 0; j < temp2.length; j++) {
                                String one = date[y];
                                String two = temp2[j]['date'].toString();
                                one = one.substring(0, 4) + one.substring(5, 7) +
                                    one.substring(8, 10);
                                two = two.substring(0, 4) + two.substring(5, 7) +
                                    two.substring(8, 10);
                                if (one.contains(two)) {
                                  if (temp2[j]['total_vaccinations'] != null) {
                                    total[y] = total[y] + temp2[j]['total_vaccinations'];
                                  }
                                  else if(temp2[j]['people_vaccinated'] != null){
                                    total[y] = total[y] + temp2[j]['people_vaccinated'];
                                  }
                                  else if(temp2[j]['people_fully_vaccinated'] != null){
                                    total[y] = total[y] + temp2[j]['people_fully_vaccinated'];
                                  }
                                }
                              }
                            }
                            y++;
                          }
                          for(int i = date.length - 1; i >= 0;i--){
                            dates.add(date[i]);

                          }
                          double ss = 0;
                          for(int a = 27; a >=0; a--){
                            spots.add(FlSpot(ss, total[a]));
                            ss++;
                          }
                          (context as Element).markNeedsBuild();

                        },
                      ),
                      SizedBox(
                        width:40,
                      ),
                      InkWell(
                        child: Text(
                          'Graph4',
                          style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                        ),
                        onTap: () {
                          spots = [];
                          dates = [];
                          min = 80000000;
                          max = 150000000;
                          check = true;
                          List<String> date = [];
                          total = [0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0];
                          bool k = false;
                          type= 1;

                          for(int i = 0; i < graph.length; i++){
                            for(int j = 0; j < graph[i].data.length;j++){
                              if(cur == graph[i].data[j]['date'].toString()){
                                int x = 0;
                                while(x < 28){
                                  date.add(graph[i].data[j - x]['date'].toString());
                                  x++;
                                }
                                k = true;
                                break;
                              }
                              if(k == true){
                                break;
                              }
                            }
                          }
                          int y = 0;
                          while(y < 28){
                            for (int i = 0; i < graph.length; i++) {
                              List<dynamic> temp2 = graph[i].data;

                              for (int j = 0; j < temp2.length; j++) {
                                String one = date[y];
                                String two = temp2[j]['date'].toString();
                                one = one.substring(0, 4) + one.substring(5, 7) +
                                    one.substring(8, 10);
                                two = two.substring(0, 4) + two.substring(5, 7) +
                                    two.substring(8, 10);
                                if (one.contains(two)) {
                                  if (temp2[j]['daily_vaccinations'] != null) {
                                    total[y] = total[y] + temp2[j]['daily_vaccinations'];
                                  }
                                }
                              }
                            }
                            y++;
                          }
                          for(int i = date.length - 1; i >= 0;i--){
                            dates.add(date[i]);
                          }
                          double ss = 0;
                          for(int a = 27; a >=0; a--){
                            spots.add(FlSpot(ss, total[a]));
                            ss++;
                          }
                          (context as Element).markNeedsBuild();
                        },
                      ),
                    ],

                  ),
                  SizedBox(
                    height:20,
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 3,
                  ),
                  SizedBox(
                    height:20,
                  ),
                  SizedBox(
                    height:150,
                    width: 300,
                    child:FutureBuilder<AlbumList>(
                        future: futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && cur != null) {
                            if(check == false) {
                              spots = [];
                              List<String> date = [];
                              dates = [];
                              min = 8000000000;
                              max = 9500000000;
                              total = [0, 0, 0, 0, 0, 0, 0];
                              bool k = false;
                              type = 0;
                              for (int i = 0; i < graph.length; i++) {
                                for (int j = 0; j < graph[i].data.length; j++) {
                                  if (cur ==
                                      graph[i].data[j]['date'].toString()) {
                                    int x = 0;
                                    while (x < 7) {
                                      date.add(graph[i].data[j - x]['date']
                                          .toString());
                                      x++;
                                    }
                                    k = true;
                                    break;
                                  }
                                  if (k == true) {
                                    break;
                                  }
                                }
                              }
                              int y = 0;
                              while (y < 7) {
                                for (int i = 0; i < graph.length; i++) {
                                  List<dynamic> temp2 = graph[i].data;

                                  for (int j = 0; j < temp2.length; j++) {
                                    String one = date[y];
                                    String two = temp2[j]['date'].toString();
                                    one = one.substring(0, 4) +
                                        one.substring(5, 7) +
                                        one.substring(8, 10);
                                    two = two.substring(0, 4) +
                                        two.substring(5, 7) +
                                        two.substring(8, 10);
                                    if (one == two) {
                                      if (temp2[j]['total_vaccinations'] !=
                                          null) {
                                        total[y] = total[y] +
                                            temp2[j]['total_vaccinations'];
                                      }
                                      else if (temp2[j]['people_vaccinated'] !=
                                          null) {
                                        total[y] = total[y] +
                                            temp2[j]['people_vaccinated'];
                                      }
                                      else
                                      if (temp2[j]['people_fully_vaccinated'] !=
                                          null) {
                                        total[y] = total[y] +
                                            temp2[j]['people_fully_vaccinated'];
                                      }
                                    }
                                  }
                                }
                                y++;
                              }
                              for (int i = date.length - 1; i >= 0; i--) {
                                dates.add(date[i]);
                              }
                              double ss = 0;
                              for (int a = 6; a >= 0; a--) {
                                spots.add(FlSpot(ss, total[a]));
                                ss++;
                              }
                              return _buildGraph();
                            }
                            else{
                              return _buildGraph();
                            }
                          }
                          else{
                            return Container();
                          }
                        }
                    ),

                  ),
                ],
              ),

            ),

          ),
          Center(
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: Column(
                children:[
                  Row(
                      children:[
                        SizedBox(
                          width:50,
                        ),
                        InkWell(
                            child: Text(
                              'Country_name',
                              style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                            ),
                            onTap: () {
                              table = [];
                              table.add('Country                   total                    fully                    daily\n');
                              for(int i = 0; i < 7; i++){
                                   String label = "";
                                   label += graph[i].country + "            ";
                                   label += totalvacc[i].toString() + "            ";
                                   label += fullyvacc[i].toString() + "            ";
                                   label += dailyvacc[i].toString() + "            ";
                                   label += '\n';
                                   table.add(label);
                              }
                              (context as Element).markNeedsBuild();
                            }
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        InkWell(
                            child: Text(
                              'Total_vacc',
                              style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent),
                            ),
                            onTap: () {
                              table = [];
                              List<String> found = [];
                              Map<String, List<int>> multi2 = new Map<String, List<int>>.from(multi);
                              table.add('Country                   total                    fully                    daily\n');
                              for(int i = 0; i <  7; i++){
                                int max = 0;
                                int fully = 0;
                                int daily = 0;
                                var thekey;
                                multi2.forEach((k,v){
                                  if(v[0]>max) {
                                    max = v[0];
                                    thekey = k;
                                    fully = v[1];
                                    daily = v[2];
                                  }
                                });
                                multi2.remove(thekey);
                                String label = "";
                                label += thekey.toString() + "      ";
                                label += max.toString() + "      ";
                                label += fully.toString() + "      ";
                                label += daily.toString() + "      ";
                                label += '\n';
                                table.add(label);
                              }
                              (context as Element).markNeedsBuild();
                            }
                        ),
                      ]
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 3,
                  ),
                  SizedBox(
                    height: 150,
                    child: buildTable(),
                  ),
                ],
              ),

            ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.pushNamed(
            context,
            '/page2',
            arguments:{"user-msg1": (_id), "user-msg2": 'Vaccine Page',},
          );
        },
        child: Icon(Icons.list),
      ),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}

