// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: avoid_init_to_null
XFile? file;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _productName = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();

  String imageURL = '';
  bool useImage = false;

  @override
  Widget build(BuildContext context) {
    Widget inputSection = Container(
      padding: const EdgeInsets.fromLTRB(32.0, 12.0, 32.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _productName,
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextField(
            controller: _price,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
          TextField(
            controller: _description,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Add'),
        actions: [
          TextButton(
            onPressed: () async {
              if (file != null && useImage == true) {
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');

                Reference referenceImageToUpload =
                    referenceDirImages.child(file!.name);

                try {
                  await referenceImageToUpload.putFile(File(file!.path));
                  imageURL = await referenceImageToUpload.getDownloadURL();
                } catch (e) {
                  //error
                }
              } else {
                imageURL =
                    "https://firebasestorage.googleapis.com/v0/b/test-67354.appspot.com/o/images%2Flogo.png?alt=media&token=1032648e-b3c4-4dc9-bda6-e47134f321f1";
              }

              List list = <String>['null'];
              FieldValue timestamp = FieldValue.serverTimestamp();
              FirebaseFirestore.instance
                  .collection('data')
                  .add(<String, dynamic>{
                'pname': _productName.text,
                'price': int.parse(_price.text),
                'description': _description.text,
                'timestamp': timestamp,
                'timeMod': timestamp,
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'userId': FirebaseAuth.instance.currentUser!.uid,
                'imageURL': imageURL,
                'likes': int.parse('0'),
                'likeUser': list,
                'cart': list,
              });

              file = null;

              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        children: [
          DisplayImage(useImage: useImage),
          const Divider(
            height: 1,
            color: Colors.black,
          ),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                file = await imagePicker.pickImage(source: ImageSource.gallery);

                setState(() {
                  if (file == null) {
                    useImage = false;
                    return;
                  } else {
                    useImage = true;
                  }
                });

                if (file == null) return;
              },
            ),
          ),
          inputSection
        ],
      ),
    );
  }
}

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key, required this.useImage});
  final bool useImage;

  @override
  Widget build(BuildContext context) {
    return useImage == false
        ? Image.asset(
            "lib/images/logo.png",
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          )
        : Image.file(
            File(file!.path),
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          );
  }
}
