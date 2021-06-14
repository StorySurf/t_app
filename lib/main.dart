import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() => runApp(
  MyApp()
    );

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sample App",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterNotification;

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterNotification = new FlutterLocalNotificationsPlugin();
    flutterNotification.initialize(initializationSettings, onSelectNotification: notificationSelected_1);

  }

  Future _showNotification(int i) async{
    var androidDetails = new AndroidNotificationDetails("Channel ID", "Rohan Samanta", "This is my channel", importance: Importance.max);
    var iOSDetails = IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // await flutterNotification.show(0, "Task", "You created a task", generalNotificationDetails);
    var scheduledTime = DateTime.now().add(const Duration(seconds: 5));
    tz.initializeTimeZones();
    // tz.setLocalLocation(tz.getLocation('IN'));
    for( var i = 0 ; i <= 1; i++ ) {
      var k = i.toString();
      await flutterNotification.zonedSchedule(
          i,
          'Checkout this story',
          'Once upon a time...',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          generalNotificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          payload: k);
    }

  }
  int index = 1;

  @override
  Widget build(BuildContext context) {

    _showNotification(index);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "App"
        ),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () => _showNotification(index),
                  child: Text("Flutter Notification"),
                ),
                InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondRoute()),
                    );
                  },
                  child: Container(width: 300, height: 300, color: Colors.red),
                ),
                InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdRoute()),
                    );
                  },
                  child: Container(width: 300, height: 300, color: Colors.yellow),
                ),
              ],
          ),
      ),
    );
  }
  Future notificationSelected_1(String payload) async {
    if(payload == "1"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThirdRoute()),
      );
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute()),
      );
    }

  }

  Future notificationSelected_2(String payload) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute()),
    );
  }


}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Route"),
      ),
      body: Center(
        child: Text("The turtle and the rabbit"),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Text("Penguin and the polar bear"),
      ),
    );
  }
}