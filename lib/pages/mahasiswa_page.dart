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

  final String apiUrl =
      "https://script.google.com/macros/s/AKfycbyx5DRSRy_1QrOgeSsj2fMYvPoNnw9-vPuNQ4MBnnbgb9LIeLc8AuNXCM5TWH1id-dl1Q/exec";

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data berhasil dihapus"),
        backgroundColor: Colors.redAccent,
      ),
    );

    getData();
  }

  void konfirmasiHapus(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF145A32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Apakah Anda yakin ingin menghapus data mahasiswa ini?",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
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
      backgroundColor: const Color(0xFF0B3D2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF145A32),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "DATA MAHASISWA",
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF27AE60),
        icon: const Icon(Icons.person_add),
        label: const Text("Tambah"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormMahasiswaPage(
                apiUrl: apiUrl,
              ),
            ),
          );

          getData();
        },
      ),

      body: mahasiswa.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2ECC71),
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF145A32),
                        Color(0xFF2ECC71),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "DATABASE MAHASISWA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Total Mahasiswa : ${mahasiswa.length}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    itemCount: mahasiswa.length,
                    itemBuilder: (context, index) {
                      final data = mahasiswa[index];

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius:
                              BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.green.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(12),

                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                const Color(0xFF2ECC71),
                            child: Text(
                              data["id"].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            data["nama"].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.menu_book,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  data["prodi"].toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          trailing: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color:
                                      Color(0xFF2ECC71),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          FormMahasiswaPage(
                                        apiUrl: apiUrl,
                                        data: data,
                                      ),
                                    ),
                                  );

                                  getData();
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.redAccent,
                                ),
                                onPressed: () {
                                  konfirmasiHapus(
                                    data["id"]
                                        .toString(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}