import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/ToastMsg.dart';

class EditMemberDetails extends StatefulWidget {
  final String name;
  final String phone;
  final String itemSelected;
  final String id;
  final String imageUrlRef;
  const EditMemberDetails(
      {required this.name,
      required this.phone,
      required this.itemSelected,
      required this.id,
      required this.imageUrlRef});

  @override
  State<EditMemberDetails> createState() => _EditMemberDetailsState();
}

class _EditMemberDetailsState extends State<EditMemberDetails> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('add-family-member');
  var SelectedItem12 = "Choose relation";

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    String imageUrl = widget.imageUrlRef;
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
                  setState(() {});
                  print('urlllllllllllllllllll');
                  print(imageUrl);
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(
                      source: ImageSource.camera, imageQuality: 50);
                  print('11111111111111111111111111111');
                  print('${file?.path}');
                  Reference refrenceImageUrl =
                      FirebaseStorage.instance.refFromURL(imageUrl);
                  try {
                    await refrenceImageUrl.putFile(File(file!.path));
                    imageUrl = await refrenceImageUrl.getDownloadURL();
                    if (this.mounted) {
                      setState(() {
                        imageUrl = imageUrl;
                      });
                    }
                    ToastMsg().getToastMsg('Image Added!!!');

                    print('2222222222222222222222222');
                    print(imageUrl);
                  } catch (e) {
                    ToastMsg().getToastMsg(e.toString());
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: imageUrl.isEmpty
                      ? NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/83/83574.png')
                      : NetworkImage(imageUrl),
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
              // Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              print(imageUrl);
              setState(() {
                imageUrl = imageUrl;
              });
              firestore.doc(widget.id).update({
                'memberName': nameController.text.toString(),
                'relation': SelectedItem12,
                'phoneNo': phoneController.text.toString(),
                'imageUrl': imageUrl
              }).then((value) {
                Navigator.pop(context);
              });
            },
            child: Text('Update'))
      ],
    );
  }
}
