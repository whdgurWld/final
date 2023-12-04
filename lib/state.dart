// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/model/product.dart';

import 'firebase_options.dart';

enum Attending { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _data;
  List<Product> dataList = [];
  List<Product> cart = [];

  bool asc = true;
  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _data = FirebaseFirestore.instance
            .collection('data')
            .orderBy('price', descending: false)
            .snapshots()
            .listen((snapshot) {
          dataList = [];
          for (final document in snapshot.docs) {
            dataList.add(Product(
              pname: document.data()['pname'] as String,
              price: document.data()['price'] as int,
              description: document.data()['description'] as String,
              imageURL: document.data()['imageURL'] as String,
              userId: document.data()['userId'] as String,
              docID: document.id,
              timestamp: document.data()['timestamp'] as Timestamp,
              timeMod: document.data()['timeMod'] as Timestamp,
              likes: document.data()['likes'] as int,
              arr: document.data()['likeUser'] as List,
              cart: document.data()['cart'] as List,
            ));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _data?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> refresh() async {
    asc == true
        ? _data = FirebaseFirestore.instance
            .collection('data')
            .orderBy('price', descending: false)
            .snapshots()
            .listen((snapshot) {
            dataList = [];
            for (final document in snapshot.docs) {
              dataList.add(Product(
                pname: document.data()['pname'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                imageURL: document.data()['imageURL'] as String,
                userId: document.data()['userId'] as String,
                docID: document.id,
                timestamp: document.data()['timestamp'] as Timestamp,
                timeMod: document.data()['timeMod'] as Timestamp,
                likes: document.data()['likes'] as int,
                arr: document.data()['likeUser'] as List,
                cart: document.data()['cart'] as List,
              ));
            }
            notifyListeners();
          })
        : _data = FirebaseFirestore.instance
            .collection('data')
            .orderBy('price', descending: true)
            .snapshots()
            .listen((snapshot) {
            dataList = [];
            for (final document in snapshot.docs) {
              dataList.add(Product(
                pname: document.data()['pname'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                imageURL: document.data()['imageURL'] as String,
                userId: document.data()['userId'] as String,
                docID: document.id,
                timestamp: document.data()['timestamp'] as Timestamp,
                timeMod: document.data()['timeMod'] as Timestamp,
                likes: document.data()['likes'] as int,
                arr: document.data()['likeUser'] as List,
                cart: document.data()['cart'] as List,
              ));
            }
            notifyListeners();
          });
  }

  Future<void> ascDesc(bool asc) async {
    asc == true
        ? _data = FirebaseFirestore.instance
            .collection('data')
            .orderBy('price', descending: false)
            .snapshots()
            .listen((snapshot) {
            dataList = [];
            for (final document in snapshot.docs) {
              dataList.add(Product(
                pname: document.data()['pname'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                imageURL: document.data()['imageURL'] as String,
                userId: document.data()['userId'] as String,
                docID: document.id,
                timestamp: document.data()['timestamp'] as Timestamp,
                timeMod: document.data()['timeMod'] as Timestamp,
                likes: document.data()['likes'] as int,
                arr: document.data()['likeUser'] as List,
                cart: document.data()['cart'] as List,
              ));
            }
            notifyListeners();
          })
        : _data = FirebaseFirestore.instance
            .collection('data')
            .orderBy('price', descending: true)
            .snapshots()
            .listen((snapshot) {
            dataList = [];
            for (final document in snapshot.docs) {
              dataList.add(Product(
                pname: document.data()['pname'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                imageURL: document.data()['imageURL'] as String,
                userId: document.data()['userId'] as String,
                docID: document.id,
                timestamp: document.data()['timestamp'] as Timestamp,
                timeMod: document.data()['timeMod'] as Timestamp,
                likes: document.data()['likes'] as int,
                arr: document.data()['likeUser'] as List,
                cart: document.data()['cart'] as List,
              ));
            }
            notifyListeners();
          });
  }

  Future<void> refreshLoggedInUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return;
    }

    await currentUser.reload();
  }

  List<Product> getCart() {
    cart = dataList
        .where((product) =>
            product.cart.contains(FirebaseAuth.instance.currentUser!.uid))
        .toList();

    return cart;
  }
}
