import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    flutterNotification.initialize(initializationSettings, onSelectNotification: notificationSelected);

  }

  Future _showNotification() async{
    var androidDetails = new AndroidNotificationDetails("Channel ID", "Rohan Samanta", "This is my channel", importance: Importance.max);
    var iOSDetails = IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterNotification.show(0, "Task", "You created a task", generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "App"
        ),
      ),
      body: Center(
          child: RaisedButton(
            onPressed: _showNotification,
            child: Text("Flutter Notification"),
          )
      ),
    );
  }
  Future notificationSelected(String payload) async {}

}