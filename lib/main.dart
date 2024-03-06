import 'dart:isolate';

import 'package:adhan/adhan.dart';
import 'package:alarm/alarm.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/constants.dart';
import 'package:tasbih/provider/note_provider.dart';
import 'package:tasbih/provider/zikir_provider.dart';
import 'package:tasbih/screens/splash_screen.dart';
import 'NotificationService.dart';
import 'constant/app_constant.dart';
import 'constant/messages.dart';
import 'controllers/language_controller.dart';
import 'constant/dep.dart' as dep;
import 'package:timezone/data/latest.dart' as tz;

import 'package:onesignal_flutter/onesignal_flutter.dart';
void printMessage(String msg) => print('Alarm fired!: $msg');

void main() async {
  try{
    await Firebase.initializeApp();
    print('Firebase Initialized Successfully');
  } catch(e){
    print('Failed to initialized firebase $e');
  }

  WidgetsFlutterBinding.ensureInitialized();
  

  await Alarm.init();

     List<AlarmSettings> al = Alarm.getAlarms();
     for (int i = 0; i < al.length; i++) {
       if(al[i].dateTime.isBefore(DateTime.now())){
         await Alarm.stop(al[i].id);
       }

   }
  NotificationService().initNotification();

  tz.initializeTimeZones();
  Map<String, Map<String, String>> _languages = await dep.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  MobileAds.instance.initialize();
  Map? sdkConfiguration = await AppLovinMAX.initialize(
      "42Xw6KsbVHeeeEA3Xg75T4NuEEZ3LK5X38xfwhPgO9EiI0CQuF921IJuD4pD7hanaTeHtgCzRHaNPDgIzDrzBc");
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(onesignalAppID);




  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NoteProvider()),
      ChangeNotifierProvider(create: (context) => ZikirProvider()),
    ],
    child: MyApp(
      languages: _languages,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.languages});
  final Map<String, Map<String, String>> languages;

  @override
  State<MyApp> createState() => _MyAppState();
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> _initializeNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<LocalizationController>(
          builder: (localizationController) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Islam Way : Prayer Times & Qibla',
              theme: ThemeData(
                fontFamily: 'Barlow',
                primarySwatch: Colors.blue,
              ),
              locale: localizationController.locale,
              translations: Messages(languages: widget.languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
