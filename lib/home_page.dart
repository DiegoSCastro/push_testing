import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initializeFcm();
  }

  Future<void> initializeFcm() async {
    final token = await messaging.getToken();
    print(token);

    messaging.subscribeToTopic('Flavor_1');

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
      Flushbar(
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        title: message.notification?.title,
        message: message.notification?.body,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 5),
        onTap: (_) {
          // Navigator.of(context).pushNamed(message.data['route']);
        },
        icon: const Icon(
          Icons.message,
          color: Colors.white,
        ),
      ).show(context);

      print('Mensagem Recebida: '
          '${message.notification?.title} - ${message.notification?.body}');
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    ///Toque da mensagem app background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('${message.notification?.title} - ${message.notification?.body}');
    });

    ///Toque da mensagem app terminated
    final RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      print('${message.notification?.title} - ${message.notification?.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
      ),
    );
  }
}
