import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan")),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshotBarang) {
          if (!snapshotBarang.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('supplier')
                .snapshots(),
            builder: (context, snapshotSupplier) {
              if (!snapshotSupplier.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var barang = snapshotBarang.data!.docs;
              var supplier = snapshotSupplier.data!.docs;

              // TOTAL BARANG
              int totalBarang = barang.length;

              // TOTAL SUPPLIER
              int totalSupplier = supplier.length;

              // STOK SEDIKIT
              var stokSedikit = barang.where((item) {
                return item['stock'] <= 5;
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CARD TOTAL
                    Row(
                      children: [
                        Expanded(
                          child: cardLaporan(
                            "Total Barang",
                            totalBarang.toString(),
                            Icons.inventory,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: cardLaporan(
                            "Total Supplier",
                            totalSupplier.toString(),
                            Icons.local_shipping,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // JUDUL
                    const Text(
                      "Barang Stok Sedikit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // LIST STOK SEDIKIT
                    Expanded(
                      child: ListView.builder(
                        itemCount: stokSedikit.length,

                        itemBuilder: (context, index) {
                          var item = stokSedikit[index];

                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.warning,
                                color: Colors.orange,
                              ),

                              title: Text(item['name']),

                              subtitle: Text("Stock tersisa: ${item['stock']}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget cardLaporan(String title, String value, IconData icon) {
    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Icon(icon, size: 40),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }
}
