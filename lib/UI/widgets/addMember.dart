import 'dart:io';

import 'package:family_app/services/ToastMsg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddMemberAlert extends StatefulWidget {
  AddMemberAlert({super.key});

  @override
  State<AddMemberAlert> createState() => _AddMemberAlertState();
}

class _AddMemberAlertState extends State<AddMemberAlert> {
  final nameController = TextEditingController();
  final relationController = TextEditingController();
  final phoneController = TextEditingController();
  final addData = FirebaseFirestore.instance.collection('add-family-member');
  String SelectedItem12 = "Choose relation";
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add Family Member'),
      content: Expanded(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 50,
              child: InkWell(
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
                  print('File path is ${file?.path}');
                  String ImageId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Reference refrence = FirebaseStorage.instance.ref();
                  Reference referenceFolder = refrence.child('images');

                  Reference referenceImages = referenceFolder.child(ImageId);
                  try {
                    await referenceImages.putFile(File(file!.path));
                    imageUrl = await referenceImages.getDownloadURL();
                    setState(() {});
                    if(imageUrl.isEmpty){
                      imageUrl='https://cdn-icons-png.flaticon.com/512/83/83574.png';
                    }
                    ToastMsg().getToastMsg('Image Added');
                  } catch (e) {
                    print(e.toString());
                    ToastMsg().getToastMsg(e.toString());
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: imageUrl.isEmpty?NetworkImage('https://cdn-icons-png.flaticon.com/512/83/83574.png'):NetworkImage(imageUrl),
                  radius: 40,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Enter Member Name',
                  hintText: 'Enter Member Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: DropdownButton<String>(
                    underline: SizedBox(),
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text('Choose relation'),
                        value: 'Choose relation',
                      ),
                      DropdownMenuItem(
                        child: Text('Mother'),
                        value: 'Mother',
                      ),
                      DropdownMenuItem(
                        child: Text('Father'),
                        value: 'Father',
                      ),
                      DropdownMenuItem(
                        child: Text('Sister'),
                        value: 'Sister',
                      ),
                      DropdownMenuItem(
                        child: Text('Brother'),
                        value: 'Brother',
                      ),
                      DropdownMenuItem(
                        child: Text('Friend'),
                        value: 'Friend',
                      ),
                    ],
                    value: SelectedItem12,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    onChanged: (String? newValue) {
                      setState(() {
                        SelectedItem12 = newValue!;
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10),
                  )),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              print('Selcted Relative : $SelectedItem12');
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
              print(FirebaseAuth.instance.currentUser!.uid);
              String id = DateTime.now().microsecondsSinceEpoch.toString();
              addData.doc(id).set({
                'id': id,
                'memberName': nameController.text.toString(),
                'relation': SelectedItem12,
                'phoneNo': phoneController.text.toString(),
                'imageUrl': imageUrl,
                'uid':FirebaseAuth.instance.currentUser!.uid,
              }).then((value) {
                ToastMsg().getToastMsg('Relative Added!!!');
                Navigator.pop(context);
              }).onError((error, stackTrace) {
                ToastMsg().getToastMsg(error.toString());
              });
            },
            child: Text('Submit'))
      ],
    );
  }
}
