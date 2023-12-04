import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modernlogintute/auth.dart';
import 'package:modernlogintute/components/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              Image.asset('lib/images/diamond.png'),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  Button(
                    imagePath: 'lib/images/google.png',
                    onTap: () async {
                      await Auth().signInWithGoogle();

                      final userDocRef = FirebaseFirestore.instance
                          .collection('user')
                          .doc(FirebaseAuth.instance.currentUser!.uid);

                      final doc = await userDocRef.get();
                      if (!doc.exists) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'status_message':
                              "I promise to take the test honestly before GOD",
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'email': FirebaseAuth.instance.currentUser!.email,
                          'name': FirebaseAuth.instance.currentUser!.displayName
                        });
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/');
                    },
                    text: "Google",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Button(
                    imagePath: 'lib/images/anonymous.png',
                    onTap: () async {
                      await Auth().signInAnonymously();

                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'status_message':
                            "I promise to take the test honestly before GOD",
                        'uid': FirebaseAuth.instance.currentUser!.uid
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/');
                    },
                    text: "Anonymous",
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
            ],
          ),
        ),
      ),
    );
  }
}
