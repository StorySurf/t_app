import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'fcm_item.dart';



Future<void> main() async {

  runApp(
      MyApp()
  );
}

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("Item ${item.itemId} has been updated"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }
  String _homeScreenText = "Waiting for token...";

  initializeFCM(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterNotification = new FlutterLocalNotificationsPlugin();
    flutterNotification.initialize(initializationSettings, onSelectNotification: notificationSelected_1);
    initializeFCM();
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