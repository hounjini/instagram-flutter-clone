import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/main.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/follow_button.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postData = [];
  int followingCount = 0;
  int followersCount = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postData = postSnap.docs;

      followersCount = userData['followers'].length;
      followingCount = userData['following'].length;

      //상대방 (현재화면)의 uid의 followers에 현재user의 uid가 있으면 following중.
      isFollowing = (userData['followers'] as List)
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget getSignOutORFollowingUnfollowingButton() {
    if (FirebaseAuth.instance.currentUser!.uid == widget.uid) {
      return FollowButton(
          backgroundColor: mobileBackgroundColor,
          borderColor: Colors.grey,
          function: () async {
            await AuthMethods().signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MyApp(),
                //여기서 LoginScreen으로 가면 Login 이후에 MyAPP의 StreamBuilder에서 처리해주는 부분이 불리지 않는다.
                //따라서 MyApp()으로 가야한다.
              ),
            );
          },
          text: "Sign Out",
          textColor: primaryColor);
    } else if (isFollowing == false) {
      return FollowButton(
          backgroundColor: Colors.blue,
          borderColor: Colors.blue,
          function: () {
            FirestoreMethods()
                .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
            //함부로 다 그리지 않는다. 연관된 변수가 영향을 미치는 widget만 그린다.
            setState(() {
              followersCount += 1;
              isFollowing = true;
            });
          },
          text: "Following",
          textColor: Colors.white);
    } else {
      return FollowButton(
          backgroundColor: Colors.black,
          borderColor: Colors.black,
          function: () {
            FirestoreMethods()
                .followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
            setState(() {
              followersCount -= 1;
              isFollowing = false;
            });
          },
          text: "Unfollowing",
          textColor: Colors.white);
    }
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']), //없는걸 부르려고 해서 일단 여기가 오류가 난다.
              //future builder로 여기도 다 바꿔야한다.
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize
                                      .max, // ROW에 들어가는 컨텐츠 크기만큼만 사용.
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postData.length, "Posts"),
                                    buildStatColumn(
                                        followersCount, "Followers"),
                                    buildStatColumn(
                                        followingCount, "Followings"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getSignOutORFollowingUnfollowingButton()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1 / 1),
                    itemCount: postData.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        postData[index]['postUrl'],
                        fit: BoxFit.cover,
                      );
                    })
                // FutureBuilder로 강의에선 했지만 나는 이미 list로 가지고 있으므로 grid view builder를 쓰자.
              ],
            ),
          );
  }
}
