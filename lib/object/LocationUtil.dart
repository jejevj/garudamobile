import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garudajayasakti/object/Jarak.dart';
import 'package:garudajayasakti/object/User.dart';

class LocationUtil {
  static String latitude = 'waiting...';
  static String longitude = 'waiting...';
  static String altitude = 'waiting...';
  static String accuracy = 'waiting...';
  static String bearing = 'waiting...';
  static String speed = 'waiting...';
  static String time = 'waiting...';
  static int userid = 6;
  static Timer? locationUpdateTimer;
  static bool isNearbyNotificationShown = false;
  static String? kodePengiriman;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> startBackgroundLocationUpdates(int UserID) async {

    // Memulai timer untuk pembaruan lokasi setiap 30 detik
    locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      BackgroundLocation.setAndroidNotification(
        title: 'Background service is running',
        message: 'Background location in progress',
        icon: '@drawable/logo', // Sesuaikan dengan ikon aplikasi Anda
      );
    });

    await BackgroundLocation.startLocationService(
      distanceFilter: 0, //meter
    );

    BackgroundLocation.getLocationUpdates((location) {
      updateLocation(location,UserID);
    });
    if (RouteInfo().jarakDalamKM < 1 && !isNearbyNotificationShown && kodePengiriman!=null) {
      LocationUtil()._showNotification('Lokasi Tujuan ${kodePengiriman}', "Tujuan anda sudah dekat");
      isNearbyNotificationShown = true;
    } else if (RouteInfo().jarakDalamKM >= 1) {
      // Reset flag jika jarak lebih dari atau sama dengan 1
      isNearbyNotificationShown = false;
    }
  }

  static void updateLocation(Location location,int userID) {
    latitude = location.latitude.toString();
    longitude = location.longitude.toString();
    altitude = location.altitude.toString();
    accuracy = location.accuracy.toString();
    bearing = location.bearing.toString();
    speed = location.speed.toString();
    time = DateTime.fromMillisecondsSinceEpoch(location.time!.toInt()).toString();

    User.updateLocation(userID, location.latitude,location.longitude);
    print("lokasi berubah");
    print(kodePengiriman);

  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',

      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

}
