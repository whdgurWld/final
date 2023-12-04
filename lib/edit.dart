// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modernlogintute/model/product.dart';
import 'package:modernlogintute/state.dart';
import 'package:provider/provider.dart';

XFile? file;

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.product});
  final Product product;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String filePath = '';
  final _productName = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();

  String imageURL = '';
  bool useImage = true;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    filePath = widget.product.imageURL;
    _productName.text = widget.product.pname;
    _price.text = widget.product.price.toString();
    _description.text = widget.product.description;

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
        leadingWidth: 70,
        title: const Text('Edit'),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (file != null && useImage == false) {
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

                FirebaseFirestore.instance
                    .collection('data')
                    .doc(widget.product.docID)
                    .set({
                  'pname': _productName.text,
                  'price': int.parse(_price.text),
                  'description': _description.text,
                  'timestamp': widget.product.timestamp,
                  'name': FirebaseAuth.instance.currentUser!.displayName,
                  'userId': widget.product.userId,
                  'imageURL': imageURL,
                  'timeMod': FieldValue.serverTimestamp(),
                  'likes': widget.product.likes,
                  'likeUser': widget.product.arr,
                  'cart': widget.product.cart,
                });
              } else {
                FirebaseFirestore.instance
                    .collection('data')
                    .doc(widget.product.docID)
                    .set({
                  'pname': _productName.text,
                  'price': int.parse(_price.text),
                  'description': _description.text,
                  'timestamp': widget.product.timestamp,
                  'name': FirebaseAuth.instance.currentUser!.displayName,
                  'userId': widget.product.userId,
                  'imageURL': widget.product.imageURL,
                  'timeMod': FieldValue.serverTimestamp(),
                  'likes': widget.product.likes,
                  'likeUser': widget.product.arr,
                  'cart': widget.product.cart,
                });
              }

              appState.refresh();

              // ignore: use_build_context_synchronously
              Navigator.popAndPushNamed(context, '/');
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        children: [
          DisplayImage(
            useImage: useImage,
            product: widget.product,
          ),
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
                    useImage = true;
                    return;
                  } else {
                    useImage = false;
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
  const DisplayImage(
      {super.key, required this.useImage, required this.product});
  final bool useImage;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return useImage == true
        ? Image.network(
            product.imageURL,
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
