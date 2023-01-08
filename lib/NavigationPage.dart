import 'package:family_dental_clinic/Authentication/auth_controller.dart';
import 'package:family_dental_clinic/infra/Constants.dart';
import 'package:family_dental_clinic/infra/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:family_dental_clinic/Screens/Login.dart';
import 'package:family_dental_clinic/Screens/HomePage/HomePage.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthController(context).isSignedIn(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (kDebugMode) {
              print(
                  'auth: ${AuthController(context).currentUser}, googleAuth: ${GoogleSignIn().currentUser}');
            }

            if (AuthController(context).currentUser != null && snapshot.data) {
              return FutureBuilder<UserData>(
                future: Utils(context).syncUserData(),
                builder: (BuildContext cntx, AsyncSnapshot<UserData> ss) {
                  if (ss.hasData) {
                    return HomePage(
                        isAdmin: ss.data?.userRole == UserRole.admin);
                  } else if (ss.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Fluttertoast.showToast(msg: messages.somethingWentWrong);
                    return const Center();
                  }
                },
              );
            } else {
              return const LoginPage();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Fluttertoast.showToast(msg: messages.somethingWentWrong);
            return const Center();
          }
        });
  }
}
