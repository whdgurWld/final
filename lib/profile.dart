import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: (() async {
              if (!user!.isAnonymous) {
                GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.disconnect();
              }
              signUserOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/login');
            }),
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: user!.isAnonymous == false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    user.photoURL!,
                    width: MediaQuery.of(context).size.width * 0.60,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  user.uid,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 75,
                  endIndent: 75,
                  height: 5,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 70),
                    const Text(
                      'Jonghyuk Park',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'I promise to take the test honestly\n before God',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "lib/images/logo.png",
                    width: MediaQuery.of(context).size.width * 0.60,
                    fit: BoxFit.fill,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  user.uid,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  indent: 75,
                  endIndent: 75,
                  height: 5,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anonymous",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 70),
                    Text(
                      'Jonghyuk Park',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'I promise to take the test honestly\n before God',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
