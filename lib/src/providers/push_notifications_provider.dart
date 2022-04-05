import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/providers/driver_provider.dart';

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


  void dispose(){
    _streamController?.onCancel;
  }
}