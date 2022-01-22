import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:instagram/resources/firestore_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPostScreen> {
  Uint8List? _file = null;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage({
    required String uid,
    required String username,
    required String profileImage,
  }) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          description: _descriptionController.text,
          file: _file!,
          profImage: profileImage,
          uid: uid,
          username: username);
      setState(() {
        _isLoading = false;
      });
      if (res == "success") {
        clearImage();
        showSnackBar("Uploading image success", context);
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  //simple dialog box를 제거.
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  //simple dialog box를 제거.
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  //simple dialog box를 제거.
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
      _descriptionController.text = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_file == null) {
      return Center(
        child: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: () => _selectImage(context),
        ),
      );
    }

    User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: Text("Post to"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              postImage(
                  profileImage: user!.photoUrl,
                  uid: user.uid,
                  username: user.username);
            },
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: LinearProgressIndicator())
              : Padding(
                  padding: EdgeInsets.only(top: 0),
                ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "write a caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                  controller: _descriptionController,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.memory(_file!).image,
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
