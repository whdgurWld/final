// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  const Product(
      {required this.pname,
      required this.price,
      required this.description,
      required this.docID,
      required this.imageURL,
      required this.userId,
      required this.timestamp,
      required this.timeMod,
      required this.likes,
      required this.arr,
      required this.cart});

  final String pname;
  final int price;
  final String description;
  final String docID;
  final String imageURL;
  final String userId;
  final Timestamp timestamp;
  final Timestamp timeMod;
  final int likes;
  final List arr;
  final List cart;
}
