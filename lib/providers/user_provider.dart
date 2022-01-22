import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/resources/auth_method.dart';

/*
flutter에서는 모든것이 위젯이다
어떤 위젯이 어떤 위젯의 상태를 변화시키기 위해서는, 타겟위젯을 가지고 있는 부모위젯에게 알려야한다
그래야 그 부모위젯이 새로운 상태의 위젯을 새로 그리기 때문이다
이렇게 하기 위해서는 부모에게 상태변화를 알리는 callback함수를 만들고 이것을 하위 위젯에게 계속 전달해도 된다
그런데 이렇게하면 callback함수를 가지고 다녀야 해서 힘들다.
https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
https://github.com/flutter/samples/tree/master/provider_shopper

이때 provider 패키지를 쓴다.

ChangerNotifier에서 notifyListeners() 쏘고,
변화시키고 싶은 위젯의 부모중 하나를 ChangeNotifierProvider()로 감싸고,
변화시킬 위젯 자체는 Consumer<ChangeNotifier를 구현한 어떤 class> (builder..) 로 만든다.
혹은 Consumer실행 없이 Provider.of(context)로 Provider객체를 가져와서 그대로 쓸 수도 있다.

*/

//https://github.com/rrousselGit/provider/blob/master/resources/translations/ko-KR/README.md
//https://boilerplate.tistory.com/41

// https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple
class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    //ChangeNotifier를 구현하는 측에서 notifyListener()를 날린다.
    //이러면 ChangeNotifierProvider의 child로 붙어있는 위젯 중,
    //Cunsumer<UserProvider>(builder: ...) 로 붙어있는 builder를 다 실행해 준다.
    //widget tree를 위에서부터 하나씩 보고 따라가는거네.
    notifyListeners();
  }
}
