import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_dark.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<String>? login_res; //초기값 null. 나중에 진짜 Future를 넣어주자.
  bool initialized = false;

  void navigateToSignup() {
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignupScreen()));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void loginUser() async {
    setState(() {
      login_res = AuthMethods().loginUser(
          email: _emailController.text, password: _passwordController.text);
    });
    //future에 로직은 then으로 붙인다.
    //future builder는 오직 widget을 만드는데만 사용한다.
    //초기값이 null이지만 여기서는 절대 null일 수 없으므로 !를 붙여준다.
    login_res!.then((String result) {
      showSnackBar("future is done - " + result, context);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //약간의 마진을 위한 flex box
              //부모의 공간을 전체 flex대비 현재 내꺼만큼 나눠갖기.
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              TextFieldInput(
                hintText: 'Enter your email',
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Password',
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              InkWell(
                child: Container(
                  //https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
                  child: FutureBuilder<String>(
                      future: login_res,
                      builder: (context, snapshot) {
                        // 사실상 done, waiting을 쓰면 됨.
                        // waiting -> progress bar 돌기
                        // done -> 이때는 값을 확인하자.
                        // none -> future가 null일때. (아직 future를 넣어주지 않은 경우 쓰자.)
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          print("connection state: active");
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          //future가 null인 상태
                          //아직 future에 Future<> 를 넣어주지 않은 상태이므로 Text를 보여주자.
                          //아직 로그인을 한번도 시도하지 않은 상태.
                          print("Connection statue: none (future is null)");
                          return Text("Login");
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          //future가 완성되었음.
                          print("Connection statue: done");
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          //waiting: await에서 대기하고 있는 상태. 즉 future가 아직 완성되지 않은 상태.
                          print(
                              "Connection statue: waiting => show circular progress indicator");
                          return const CircularProgressIndicator(
                              color: primaryColor);
                        }

                        if (snapshot.hasData) {
                          if (snapshot.data == "initialData") {
                            print("Initial state: show login button");
                            return Text("Login");
                          } else if (snapshot.data == "success") {
                            print("Login success. lets go home screen.");
                            // snackbar같은건 logic이라서 쓰면 안됨 오직 widget생성에서만 쓸 수 있음.
                            //showSnackBar("Login succesfully.", context);
                            return Text("Login successfully");
                          } else {
                            print("Login error : " + snapshot.data!);
                            return Text("Login");
                          }
                        } else if (snapshot.hasError) {
                          print("snapshot has error!");
                        } else {
                          print(
                              "future is not ready. show circular progress on snapshot else statement");
                          return const CircularProgressIndicator(
                              color: primaryColor);
                        }
                        return Text("Login: should not be here.");
                      }),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
                onTap: () => loginUser(),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Dont have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () => navigateToSignup(),
                    child: Container(
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
              // text field input for password
              // login image
              // transition to signing up
            ],
          ),
        ),
      ),
    );
  }
}
