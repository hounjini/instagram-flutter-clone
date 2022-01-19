import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_dark.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';

void main() async {
  //firebase초기화에 native code를 실행해야 하는데,
  //flutter는 platform(android, 브라우저, ios)와 독립이고, 서로 채널을 통해 메시지를 주고 받는다.
  //채널은 flutter widget과 연결됨.
  //따라서 먼저 위젯을 바인딩 해줘야 함.
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    print("this is web version.");
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCMmq1x9l30G07JC0zvZii1RXUFjq2rmwY",
        appId: "1:820177874143:web:8692d7166f32aae4248d6a",
        messagingSenderId: "820177874143",
        projectId: "hounjini-instgram",
        storageBucket: "hounjini-instgram.appspot.com",
      ),
    );
  } else {}
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      /*
,*/
      //stream builder <-- stream controller에 값이 들어가면 화면 그려줌.
      //future builder <-- future에 대해서 값이 튀어나오거나 state가 변경면 화면그려줌.

      //idTokenChanges: 토큰 변경, 다른곳에 로그인등..계속 변함
      //userChanges: update password 등 여러 이벤트 발생.
      //authStateChanges: login, logout
      //home: LoginScreen(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                //future가 null이 아닌 값을 받았을 경우
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: primaryColor));
            }

            return LoginScreen();
          }),
    );
  }
}
