import 'package:family_dental_clinic/firebase_options.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:family_dental_clinic/provider/user_data_provider.dart';
import 'package:family_dental_clinic/provider/appointments_response_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:family_dental_clinic/navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ListenableProvider<UserDataProvider>(create: (_) => UserDataProvider()),
      ListenableProvider<AppointmentsResponseProvider>(
          create: (_) => AppointmentsResponseProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FireStoreUtils().updateAppointmentsStatusToExpire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AuthController(context).signout();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Navigation(),
      ),
    );
  }
}
