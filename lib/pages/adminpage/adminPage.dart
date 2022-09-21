import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/usermodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/sherdprefrnce/sprfrnce.dart';

class adminPage extends StatefulWidget {
  TabController tabController;

  adminPage(this.tabController);

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {

  bool status = false;
  bool check = false;
  String auth = FirebaseAuth.instance.currentUser!.uid;
  late UserModal userModal;
  TextEditingController tname = TextEditingController();
  TextEditingController tphone = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final storageRef = FirebaseStorage.instance;
  String? imageUrl;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        floatingActionButton: status ? null : Container(
           alignment: Alignment.bottomRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(onPressed: () {
              setState(() {
                status = true;
              });
            },
              child: Icon(Icons.edit),
              heroTag: 'btn1',
            ),
            SizedBox(height: 20),
            FloatingActionButton(onPressed: () async {
              await GoogleSignIn().signOut();
              widget.tabController.animateTo(0);
              SherdPrefe.prefs = await SharedPreferences.getInstance();
              SherdPrefe.prefs!.clear();
            },
              child: Icon(Icons.logout),
              heroTag: 'btn2',
            ),
          ],
          ),
        ),
        body: status ? StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection("user").doc(auth).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("somthing wrong");
              return Center(child: Text("somthing wrong"));
            } else if (snapshot.hasData) {

              final user = snapshot.data!;
              UserModal userModal = UserModal.fromJson(user.data() as Map<String, dynamic>);

              return  SingleChildScrollView(
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: userModal.email,
                        decoration: const InputDecoration(
                          enabled: false,
                          border: OutlineInputBorder(),
                          labelText: 'email',
                          hintText: 'Enter Your email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: tname,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'name',
                          hintText: 'Enter Your Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: tphone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
                          hintText: 'Enter Your Phone',
                        ),
                      ),
                    ),
                    GFButton(onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text("Choose File"),

                          actions: [
                            IconButton(onPressed: () async {

                            


                            }, icon: Icon(Icons.photo_size_select_actual)),
                            Text("gallery"),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(onPressed: () async {
                                Navigator.pop(context);
                                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                var file = File(photo!.path);

                                if (photo != null){
                                  var snapshot = await storageRef.ref().child('images/${photo.name}').putFile(file);
                                  print("ok");
                                  var downloadUrl = await snapshot.ref.getDownloadURL();
                                  setState(() {
                                    imageUrl = downloadUrl;
                                  });
                                  if(downloadUrl == null){
                                    CircularProgressIndicator();
                                  }
                                }


                              }, icon: Icon(Icons.camera_alt)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Text("Camera"),
                            ),
                          ],
                        );
                      },);

                    },text: 'Select Image',type: GFButtonType.transparent),
                    imageUrl != null ? ElevatedButton(onPressed: () {

                      FirebaseFirestore.instance.collection("user").doc(auth).update({'name':tname.text,'phone':tphone.text,'userImage':imageUrl});
                      setState(() {
                        status = false;
                      });
                      tphone.clear();
                      tname.clear();
                    }, child: Text("Update")) : Text("Waiting "),
                  ],
                ),
              );
            }else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ): StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("user").doc(auth).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("somthing wrong");
              return Center(child: Text("somthing wrong"));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              UserModal userModal = UserModal.fromJson(user.data() as Map<String, dynamic>);
              return ListView(
                children: [
                  (userModal.userImage == null) ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SvgPicture.asset("assets/icons/user (1).svg",height: 150,width: 150,),
                  ) : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(backgroundImage: NetworkImage("${userModal.userImage}"),radius: 40),
                  ),
                  ListTile(
                    title: Center(child: Text("${userModal.email}")),
                  ),
                  // Spacer(),
                  (userModal.type == "Admin") ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () async {
                      widget.tabController.animateTo(1);
                    }, child: Text("Show User Data")),
                  ) : Center(child: Text("User"),),

                ],
              );
            }else
              {
                return Center(child: CircularProgressIndicator(),);
              }
          },
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future pickPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if(photo == null){
      return;
    }



  }


}
