import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{
  final _firabaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async{
    await _firabaseMessaging.requestPermission();

    final fCMToken = await _firabaseMessaging.getToken();
    
    print('Token:  $fCMToken');
  }
}