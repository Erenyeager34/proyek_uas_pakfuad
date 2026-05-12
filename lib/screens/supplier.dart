import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();

  // TAMBAH SUPPLIER
  Future<void> tambahSupplier() async {
    await FirebaseFirestore.instance.collection('supplier').add({
      'nama_supplier': namaController.text,
      'alamat': alamatController.text,
      'telepon': teleponController.text,
    });

    namaController.clear();
    alamatController.clear();
    teleponController.clear();

    if (!mounted) return;

    Navigator.pop(context);
  }

  // HAPUS SUPPLIER
  Future<void> hapusSupplier(String id) async {
    await FirebaseFirestore.instance.collection('supplier').doc(id).delete();
  }

  // FORM TAMBAH
  void showForm() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Supplier"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: "Nama Supplier"),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: "Alamat"),
                ),
                TextField(
                  controller: teleponController,
                  decoration: const InputDecoration(labelText: "Telepon"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: tambahSupplier,
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supplier")),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('supplier').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var supplier = data[index];

              return Card(
                child: ListTile(
                  title: Text(supplier['nama_supplier']),
                  subtitle: Text(
                    "${supplier['alamat']} | ${supplier['telepon']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      hapusSupplier(supplier.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
