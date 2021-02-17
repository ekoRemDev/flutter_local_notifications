import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    calculateDifferences();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);

  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }


  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }


  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: 'flutter devs',
        htmlFormatContentTitle: true,
        summaryText: 'summaryText',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }


  Future<void> scheduleNotification() async {
    var rng = new Random();
    var min = rng.nextInt(2);
    debugPrint("scheduler will run in $min minutes...");

    var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: min));
    // var scheduledNotificationDateTime = DateTime(2020, 10, 5, 16, 52, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);

      Timer(Duration(minutes: min), () {
        debugPrint("Yeah, this line is printed after $min seconds");
        scheduleNotification();
      });


  }


  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }


  showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo ');
  }


  calculateDifferences(){
    final birthday = DateTime(1980, 6, 13, 0, 0, 0);
    final date2 = DateTime.now();
    // final difference = date2.difference(birthday).inDays;

    print("day " + date2.difference(birthday).inDays.toString());
    print("hours " + date2.difference(birthday).inHours.toString());
    print("minute " + date2.difference(birthday).inMinutes.toString());
    print("second " + date2.difference(birthday).inSeconds.toString());
  }


  showActiveNotifications() async{
    final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    final List<ActiveNotification> activeNotifications =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();


    // print("Pending Notifications " + pendingNotificationRequests.length.toString());
    // print("activeNotifications " + activeNotifications.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Flutter notification demo'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: showNotification,
              child: new Text(
                'showNotification',
              ),
            ),
            RaisedButton(
              onPressed: cancelNotification,
              child: new Text(
                'cancelNotification',
              ),
            ),
            RaisedButton(
              onPressed: scheduleNotification,
              child: new Text(
                'scheduleNotification',
              ),
            ),
            RaisedButton(
              onPressed: showBigPictureNotification,
              child: new Text(
                'showBigPictureNotification',
              ),
            ),
            RaisedButton(
              onPressed: showNotificationMediaStyle,
              child: new Text(
                'showNotificationMediaStyle',
              ),
            ),
            RaisedButton(
              onPressed: showActiveNotifications,
              child: new Text(
                'showActiveNotifications',
              ),
            ),

          ],
        ),
      ),
    );
  }

}


class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
