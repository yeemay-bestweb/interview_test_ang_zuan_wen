import 'package:calorie_count_app/model/notification_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calorie_count_app/constants.dart';
import 'package:flutter/services.dart';
import 'package:calorie_count_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  SharedPreferences sharedPreferences;
  NotificationPreferences notificationPreferences;

  Future<NotificationPreferences> fetchNotificationPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('notificationsOn') &&
        sharedPreferences.containsKey('notificationsTime')) {
      return NotificationPreferences(
          sharedPreferences.getBool('notificationsOn'),
          TimeOfDay.fromDateTime(DateFormat.jm()
              .parse(sharedPreferences.getString('notificationsTime'))));
    } else {
      return NotificationPreferences(false, TimeOfDay(hour: 20, minute: 0));
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    if (tod != null) {
      final now = new DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, tod?.hour, tod?.minute) ??
              DateTime.now();
      final format = DateFormat.jm(); //"6:00 AM"
      return format.format(dt);
    } else
      return '8:00PM';
  }

  Future<void> _showDailyAtTime() async {
    _cancelNotification();
    print('Notifications On at ' +
        notificationPreferences.notificationsTime.hour.toString() +
        notificationPreferences.notificationsTime.minute.toString());
    var time = Time(notificationPreferences.notificationsTime.hour,
        notificationPreferences.notificationsTime.minute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'calorie_count_app.channelID',
        'calorie_count_app.channelName',
        'Calorie Count App Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Calorie Count App',
        'Have you input your calorie intake today?',
        time,
        platformChannelSpecifics);
  }

  Future<void> _cancelNotification() async {
    print('Notifications Off');
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  @override
  void initState() {
    fetchNotificationPrefs().then((notifications) {
      setState(() {
        this.notificationPreferences = notifications;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'NOTIFICATIONS',
                  style: kHintTextStyle.copyWith(
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.7,
                      child: Container(
                        height: 150.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Daily Notifications'),
                              ),
                              Switch(
                                value:
                                    notificationPreferences?.notificationsOn ??
                                        false,
                                onChanged: (value) async {
                                  setState(() {
                                    notificationPreferences.notificationsOn =
                                        value;
                                    print(notificationPreferences
                                        .notificationsOn);
                                  });
                                  print('save new notifications on');
                                  if (notificationPreferences.notificationsOn) {
                                    await _showDailyAtTime();
                                  } else {
                                    await _cancelNotification();
                                  }
                                  sharedPreferences.setBool(
                                      'notificationsOn', value);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () async {
                                notificationPreferences.notificationsTime =
                                    await showTimePicker(
                                        context: context,
                                        initialTime: notificationPreferences
                                                ?.notificationsTime ??
                                            TimeOfDay(hour: 20, minute: 0));
                                setState(() {});
                                sharedPreferences.setString(
                                    'notificationsTime',
                                    formatTimeOfDay(notificationPreferences
                                        ?.notificationsTime));
                                if (notificationPreferences != null) {
                                  print('save new notification time');
                                  if (notificationPreferences.notificationsOn) {
                                    await _showDailyAtTime();
                                  } else {
                                    await _cancelNotification();
                                  }
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('at'),
                                  ),
                                  Text(
                                    formatTimeOfDay(notificationPreferences
                                        ?.notificationsTime),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
