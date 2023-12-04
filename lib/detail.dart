// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modernlogintute/edit.dart';
import 'package:modernlogintute/model/product.dart';
import 'package:modernlogintute/state.dart';
import 'package:provider/provider.dart';

XFile? file;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.product});

  final Product product;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  late bool isInCart;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    isInCart = appState.getCart().contains(widget.product);

    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Detail'),
        actions: [
          if (user == widget.product.userId)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(product: widget.product),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          if (user == widget.product.userId)
            IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('data')
                    .doc(widget.product.docID)
                    .delete();

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: ListView(
        children: [
          Image.network(
            widget.product.imageURL,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.product.pname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontSize: 20),
                      ),
                      LikeButton(product: widget.product),
                    ],
                  ),
                  Text(
                    formatter.format(widget.product.price),
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    'creator: ${widget.product.userId}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                // '${DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.product.timestamp.toDate().toString(), true).toLocal()}',
                                // '${DateTime.now().toUtc().toLocal()}',
                                '${convert(widget.product.timestamp)}',
                                // '${DateTime.parse('${widget.product.timestamp.toDate().toLocal().toString() + 'Z'}').toLocal()}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                ' Created',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                          if (widget.product.timeMod !=
                              widget.product.timestamp)
                            Row(
                              children: [
                                Text(
                                  // '${widget.product.timeMod.toDate().toUtc()}',
                                  '${convert(widget.product.timeMod)}',
                                  // DateTime.parse('${'${widget.product.timeMod.toDate().toUtc()}Z'}'),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  ' Modified',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                      FloatingButton(product: widget.product),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime convert(Timestamp timestamp) {
    var date = DateTime.parse(timestamp.toDate().toString());
    var newDate = DateTime(date.year, date.month, date.day, date.hour + 9,
        date.minute, date.second, date.millisecond);
    return newDate;
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.product});
  final Product product;

  @override
  State<LikeButton> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButton> {
  bool inc = false;

  @override
  Widget build(BuildContext context) {
    int incremented = widget.product.likes + 1;
    return Row(
      children: [
        IconButton(
            onPressed: () async {
              if (widget.product.arr
                  .contains(FirebaseAuth.instance.currentUser!.uid)) {
                const snackBar = SnackBar(
                  content: Text('You can only do it once !!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                widget.product.arr.add(FirebaseAuth.instance.currentUser!.uid);

                await FirebaseFirestore.instance
                    .collection('data')
                    .doc(widget.product.docID)
                    .update({
                  "likes": FieldValue.increment(1),
                  "likeUser": widget.product.arr
                });

                setState(() {
                  if (inc == false) {
                    inc = true;
                  }
                });

                const snackBar = SnackBar(
                  content: Text('I LIKE IT !'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(Icons.thumb_up)),
        if (inc == true)
          Text(incremented.toString())
        else
          Text(widget.product.likes.toString()),
      ],
    );
  }
}

class FloatingButton extends StatefulWidget {
  const FloatingButton({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<FloatingButton> createState() => _FloatingButtonWidgetState();
}

class _FloatingButtonWidgetState extends State<FloatingButton> {
  bool isInCart = true;

  @override
  void initState() {
    super.initState();
    // Initialize the isInCart state based on whether the user is in the cart.
    isInCart =
        widget.product.cart.contains(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return FloatingActionButton(
      onPressed: () {
        setState(() {
          if (isInCart) {
            // Remove the product from the cart
            widget.product.cart.remove(FirebaseAuth.instance.currentUser!.uid);
            appState.cart.remove(widget.product);
          } else {
            // Add the product to the cart
            widget.product.cart.add(FirebaseAuth.instance.currentUser!.uid);
            appState.cart.add(widget.product);
          }
          isInCart = !isInCart; // Toggle the isInCart state
        });

        FirebaseFirestore.instance
            .collection('data')
            .doc(widget.product.docID)
            .set({
          'cart': widget.product.cart,
          'pname': widget.product.pname,
          'price': widget.product.price,
          'description': widget.product.description,
          'timestamp': widget.product.timestamp,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'userId': widget.product.userId,
          'imageURL': widget.product.imageURL,
          'timeMod': widget.product.timeMod,
          'likes': widget.product.likes,
          'likeUser': widget.product.arr,
        });
      },
      child:
          isInCart ? const Icon(Icons.check) : const Icon(Icons.shopping_cart),
    );
  }
}
