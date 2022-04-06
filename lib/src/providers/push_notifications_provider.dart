import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/providers/driver_provider.dart';
import 'package:give_structure/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class PushNotificationsProvider {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  StreamController _streamController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get message => _streamController.stream;

  void initPushNotifications() async {
   /* FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      <Map<String, dynamic>> data = message.data;
      print('OnMessage: $message');
      _streamController.sink.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      <Map<String, dynamic>> data = message.data;
      print('OnResume: $message');
      _streamController.sink.add(message);
    });*/


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message){
        print('OnMessage: $message');
        _streamController.sink.add(message);
      },
      onLaunch: (Map<String, dynamic> message){
        print('OnLaunch: $message');
        _streamController.sink.add(message);
        SharedPref sharedPref = new SharedPref();
        sharedPref.save('isNotification', 'true');
      },
      onResume: (Map<String, dynamic> message){
        print('OnResume: $message');
        _streamController.sink.add(message);
      }
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true
      )
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('Configuraciones para IOS fueron registradas $settings');
    });

  }

  void saveToken(String idUser, String typeUser) async {
    String token = await _firebaseMessaging.getToken();
    Map<String, dynamic> data = {
      'token': token
    };

    if(typeUser == 'client'){
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    } else {
      DriverProvider driverProvider = new DriverProvider();
      driverProvider.update(data, idUser);
    }
  }

  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAARo9nwoE:APA91bHsOYSIzUrvafDpqxb_WymvgLxW3CKBTs6A0wvf2ttEimAtFc3XmiHcfo590rPzwMcB2d_yA2rf4nN47q6Gwn1yhiduEpJRsCPHFjH_U1yy2Ch6z6uyFhu5h-yuQ3MW4uEmL3iW'
      },
      body: jsonEncode(
       <String, dynamic>  {
         'notification': <String, dynamic>{
           'body': body,
           'title': title
         },
         'priority': 'high',
         'ttl': '4500s',
         'data': data,
         'to': to
       }
      )
    );
  }

  void dispose(){
    _streamController?.onCancel;
  }
}