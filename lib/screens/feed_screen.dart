import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.messenger_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            print("build PostCard from start to end");
            //collection이 바뀔 떄 마다 firebase에서 계속 새로 collection을 날려준다.
            //그리고 하위 widget을 새로 만드는거지, 현재 부모는 새로 그리지 않기 때문에 scroll 위치는 고정되어 있다.
            //그렇네, 해당 PostCard'만'바뀌었따고 할 수 있는 방법이 없네,
            //PostCard를 그리는 rule은 여기에 정의되어 있으니까 다 그려야 하네.
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(snap: snapshot.data!.docs[index].data());
              },
            );
          }),
    );
  }
}
