import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'form_mahasiswa_page.dart';
class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  State<MahasiswaPage> createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  List mahasiswa = [];

  final String apiUrl = "https://script.google.com/macros/s/AKfycbz7Xt8OXTsdpKdXdk6eRrDm0n4lSoAUlLLTlVLd3vVaiQbHTeXtR1tXshuyT2-3XDccYQ/exec";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final response = await http.get(Uri.parse(apiUrl));

    setState(() {
      mahasiswa = jsonDecode(response.body);
    });
  }

  Future<void> hapusData(String id) async {
    final url = "$apiUrl?action=delete&id=$id";

    await http.get(Uri.parse(url));
    getData();
  }

  void konfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus data?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await hapusData(id);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormMahasiswaPage(apiUrl: apiUrl),
            ),
          );
          getData();
        },
      ),
      body: ListView.builder(
        itemCount: mahasiswa.length,
        itemBuilder: (context, index) {
          final data = mahasiswa[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(data["id"].toString()),
              ),
              title: Text(data["nama"].toString()),
              subtitle: Text(data["prodi"].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormMahasiswaPage(
                            apiUrl: apiUrl,
                            data: data,
                          ),
                        ),
                      );
                      getData();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      konfirmasiHapus(data["id"].toString());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}