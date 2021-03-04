import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'auth_wrapper.dart';
import 'muser.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  Muser muser;
  final _msgController = TextEditingController();

  void uploadMsg(String msg) async {
    CollectionReference _chco = FirebaseFirestore.instance.collection('chats');
    DocumentReference df =
        FirebaseFirestore.instance.collection('messages').doc("id");

    CollectionReference cs = df.collection("chats");

    String datetime = DateTime.now().toLocal().toString();

    await cs
        .add({
          'name': muser.name,
          'url': muser.url,
          'uid': muser.uid,
          'msg': msg,
          'dateTime': datetime
        })
        .then((value) => _msgController.clear())
        .catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
    getUser();
    fetchData();
    FirebaseFirestore.instance
        .collection('messages')
        .doc("id")
        .set({'testData': "Hello sub Collection!"})
        .then((value) => print("Success"))
        .catchError((e) => print("e $e"));
  }

  void getUser() async {
    muser = await AuthServices().getCurrentUserData();
    setState(() {});
  }

  List<Muser> docList = [];

  fetchData() {
    if (this.mounted) {
      isLoading = true;
      setState(() {});
      DocumentReference df =
          FirebaseFirestore.instance.collection('messages').doc("id");

      df.collection("chats");

      CollectionReference chatList =
          FirebaseFirestore.instance.collection("chats");

      chatList.snapshots().listen((snapshot) {
        List<QueryDocumentSnapshot> data = snapshot.docs;

        docList.clear();
        for (var i = 0; i < data.length; i++) {
          Map<String, dynamic> mdata = data[i].data();
          docList.add(Muser(
              name: mdata['name'],
              uid: mdata['uid'],
              url: mdata['url'],
              msg: mdata['msg'],
              dateTime: mdata['dateTime']));
        }

        docList.sort((a, b) =>
            DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
        isLoading = false;
        setState(() {});
        print("Done :::${docList[0].msg}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(docList.length);
    print("Hello");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                // child: Image.network(widget.muser.url),
                child: muser == null
                    ? Text("Wait")
                    : CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(muser.url),
                        backgroundColor: Colors.transparent,
                      )),
            SizedBox(
              width: 10,
            ),
            muser == null ? Text("wait") : Text(muser.name),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthServices().logOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (b) => AuthWrapper()));
            },
          )
        ],
      ),
      body: muser == null
          ? Container(
              child: Center(
                child: Text("Hello"),
              ),
            )
          : Column(
              // mainAxisSize: MainAxisSize.max,

              children: [
                Expanded(
                    child: isLoading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: docList.length,
                            itemBuilder: (c, i) {
                              return Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: CircleAvatar(
                                      radius: 10.0,
                                      backgroundImage:
                                          NetworkImage(docList[i].url),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(docList[i].msg)
                                ],
                              );
                            })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _msgController,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          print("Send");
                          uploadMsg(_msgController.text.toString());
                        },
                        child: Text("Send")),
                  ],
                ),
              ],
            ),
    );
  }
}
