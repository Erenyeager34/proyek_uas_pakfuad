import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard User"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 INFO USER
            Text("Selamat datang 👋", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            Text(
              user?.email ?? "-",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // 🔥 MENU
            const Text(
              "Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // CARD 1
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text("Lihat Barang"),
                onTap: () {
                  // nanti ke halaman barang
                },
              ),
            ),

            // CARD 2
            Card(
              child: ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Tambah Data"),
                onTap: () {
                  // nanti ke tambah data
                },
              ),
            ),

            // CARD 3
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Riwayat"),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
