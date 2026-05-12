import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBarangScreen extends StatelessWidget {
  const AdminBarangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Barang")),

      // 🔥 READ DATA
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada barang"));
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(item['name']),
                  subtitle: Text(
                    "Stock: ${item['stock']} | Rp ${item['price']}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ EDIT
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditBarangDialog(
                              id: item.id,
                              name: item['name'],
                              stock: item['stock'],
                              price: item['price'],
                            ),
                          );
                        },
                      ),

                      // 🗑️ DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('items')
                              .doc(item.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ➕ TAMBAH
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const TambahBarangDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ================= TAMBAH =================
class TambahBarangDialog extends StatefulWidget {
  const TambahBarangDialog({super.key});

  @override
  State<TambahBarangDialog> createState() => _TambahBarangDialogState();
}

class _TambahBarangDialogState extends State<TambahBarangDialog> {
  final nameController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();

  Future<void> tambahBarang() async {
    await FirebaseFirestore.instance.collection('items').add({
      'name': nameController.text,
      'stock': int.parse(stockController.text),
      'price': int.parse(priceController.text),
      'created_at': Timestamp.now(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Barang"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nama Barang"),
          ),
          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Stock"),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Harga"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(onPressed: tambahBarang, child: const Text("Simpan")),
      ],
    );
  }
}

// ================= EDIT =================
class EditBarangDialog extends StatefulWidget {
  final String id;
  final String name;
  final int stock;
  final int price;

  const EditBarangDialog({
    super.key,
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  @override
  State<EditBarangDialog> createState() => _EditBarangDialogState();
}

class _EditBarangDialogState extends State<EditBarangDialog> {
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    stockController = TextEditingController(text: widget.stock.toString());
    priceController = TextEditingController(text: widget.price.toString());
  }

  Future<void> updateBarang() async {
    await FirebaseFirestore.instance.collection('items').doc(widget.id).update({
      'name': nameController.text,
      'stock': int.parse(stockController.text),
      'price': int.parse(priceController.text),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Barang"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController),
          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(onPressed: updateBarang, child: const Text("Update")),
      ],
    );
  }
}
