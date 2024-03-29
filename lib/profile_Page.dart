import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'login_page.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  File? pickedImage;

  Future showAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick Image from",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      ImagePick(ImageSource.camera);
                      Navigator.pop(context);
                    }),
                ListTile(
                    leading: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    title: const Text("Gallery",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      ImagePick(ImageSource.gallery);
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  Future ImagePick(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() async {
        pickedImage = tempImage;
        uploadData();
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  uploadData() async {
    try {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref("ProfilePics")
          .child(GetStorage().read("PHONE_NUMBER").toString())
          .putFile(pickedImage!);
      String url = await uploadTask.ref.getDownloadURL();

      // Updating users collection in firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(GetStorage().read("PHONE_NUMBER").toString())
          .update({"profilePicUrl": url});

      // updating transaction collection of firestore
      await FirebaseFirestore.instance
          .collection("transaction")
          .where("recieverID", isEqualTo: GetStorage().read("PHONE_NUMBER"))
          .get()
          .then((value) => value.docs.forEach((element) {
                element.reference.update({"profilePicUrl": pickedImage});
              }));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Color.fromRGBO(17, 130, 20, 0.8),content: Text("Profile Pic changed")));

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Color.fromRGBO(140, 13, 1, 0.8),content: Text("Failed to update profile picture")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(GetStorage().read("PHONE_NUMBER"))
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    snapshot.data!["profilePicUrl"].toString().isNotEmpty?
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      backgroundImage:
                          NetworkImage(snapshot.data!["profilePicUrl"]),
                    ):CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person,color: Colors.white,size: 80,),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${snapshot.data!["Name"]}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "UPI ID: ${snapshot.data!["phoneNumber"]}@CodeSwift",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        showAlert();
                      },
                      child: const Text('Edit Profile Picture'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        GetStorage().write("isLoggedIn", false);
                        Get.offAll(login_Page());
                        },

                      child: const Text('Log Out'),
                    ),
                    SizedBox(height: 200,),
                    Center(
                      child: Text("Developed By: Shreyansh Khandelwal",style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white60)),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                  child: Text(
                "unable to fetch data",
                style: TextStyle(color: Colors.white),
              ));
            }
          }),
    );
  }
}
