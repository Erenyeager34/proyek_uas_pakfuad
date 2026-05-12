import 'package:flutter/material.dart';
import 'admin_barang.dart';
import 'supplier.dart';
import 'laporan.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            menuItem(context, Icons.inventory, "Data Barang"),
            menuItem(context, Icons.people, "Data User"),
            menuItem(context, Icons.add_box, "Supplier"),
            menuItem(context, Icons.bar_chart, "Laporan"),
          ],
        ),
      ),
    );
  }

  Widget menuItem(BuildContext context, IconData icon, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print("Diklik: $title");

            // DATA BARANG
            if (title == "Data Barang") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminBarangScreen()),
              );
            }

            if (title == "Laporan") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LaporanScreen()),
              );
            }

            // SUPPLIER
            if (title == "Supplier") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupplierScreen()),
              );
            }
          },

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),

              const SizedBox(height: 10),

              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
