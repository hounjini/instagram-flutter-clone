import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  //reponsive layout실행되면, addData실행됨.
  @override
  void initState() {
    super.initState();
    addData();
  }

  //listen이 false라서 한번만 실행됨 <= 모르겠음.
  addData() async {
    //https://boilerplate.tistory.com/41
    //widget tree에 변화가 없을 경우 사용 가능.
    //UserProvider객체를 생성하는게 아니고 이미 만들어진것 가져오는 것.
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      } else {
        return widget.mobileScreenLayout;
      }
    });
  }
}
