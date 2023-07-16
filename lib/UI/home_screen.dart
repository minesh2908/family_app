import 'package:family_app/UI/Auth/LoginScreen.dart';
import 'package:family_app/UI/widgets/addMember.dart';
import 'package:family_app/UI/widgets/editMemberDetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final firestore =
      FirebaseFirestore.instance.collection('add-family-member').where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  final firestore1 = FirebaseFirestore.instance.collection('add-family-member');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMemberAlert()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Home Screen'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                child: Icon(Icons.logout_outlined),
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                },
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return GestureDetector(
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Some Error');
                      }

                      return ExpansionTile(
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blueGrey,
                        title: Text(snapshot.data!.docs[index]['memberName']),
                        leading: CircleAvatar(
                          backgroundImage: (snapshot.data!.docs[index]['imageUrl'].toString()).isEmpty
                              ? NetworkImage(
                                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png')
                              : NetworkImage(snapshot
                                  .data!.docs[index]['imageUrl']
                                  .toString()),
                        ),
                        subtitle: Text(
                            snapshot.data!.docs[index]['relation'].toString()),
                        childrenPadding: EdgeInsets.all(10),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    final Uri url = Uri(
                                        scheme: 'tel',
                                        path: snapshot
                                            .data!.docs[index]['phoneNo']
                                            .toString());
                                    launchUrl(url);
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    size: 40,
                                    color: Colors.grey,
                                  )),
                              InkWell(
                                  onTap: () {
                                    final Uri url = Uri(
                                        scheme: 'sms',
                                        path: snapshot
                                            .data!.docs[index]['phoneNo']
                                            .toString());
                                    launchUrl(url);
                                  },
                                  child: Icon(
                                    Icons.message,
                                    size: 40,
                                    color: Colors.grey,
                                  ))
                            ],
                          )
                        ],
                        trailing: SizedBox(
                          width: 70,
                          child: Row(
                            children: [
                              InkWell(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditMemberDetails(
                                                imageUrlRef: snapshot.data!
                                                    .docs[index]['imageUrl'],
                                                id: snapshot.data!.docs[index]
                                                    ['id'],
                                                name: snapshot.data!.docs[index]
                                                    ['memberName'],
                                                phone: snapshot.data!
                                                    .docs[index]['phoneNo'],
                                                itemSelected: snapshot.data!
                                                    .docs[index]['relation'],
                                              )));
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                child: Icon(Icons.delete),
                                onTap: () {
                                  print('PRINTTTTTTTTTTTTTTTTTTTTTTTTTT');
                                  print(snapshot.data!.docs[index]['imageUrl']
                                      .toString());
                                  firestore1
                                      .doc(snapshot.data!.docs[index]['id']
                                          .toString())
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                        tilePadding: EdgeInsets.all(10),
                      );
                    }),
              );
            }),
      ),
    );
  }
}
