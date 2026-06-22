import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormMahasiswaPage extends StatefulWidget {
  final String apiUrl;
  final Map? data;

  const FormMahasiswaPage({
    super.key,
    required this.apiUrl,
    this.data,
  });

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final idController = TextEditingController();
  final namaController = TextEditingController();
  final prodiController = TextEditingController();

  bool get isEdit => widget.data != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      idController.text = widget.data!["id"].toString();
      namaController.text = widget.data!["nama"].toString();
      prodiController.text = widget.data!["prodi"].toString();
    }
  }

  Future<void> simpan() async {
    String url;

    if (isEdit) {
      url =
          "${widget.apiUrl}?action=update"
          "&id=${idController.text}"
          "&nama=${Uri.encodeComponent(namaController.text)}"
          "&prodi=${Uri.encodeComponent(prodiController.text)}";
    } else {
      url =
          "${widget.apiUrl}?action=create"
          "&id=${idController.text}"
          "&nama=${Uri.encodeComponent(namaController.text)}"
          "&prodi=${Uri.encodeComponent(prodiController.text)}";
    }

    await http.get(Uri.parse(url));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF27AE60),
          content: Text(
            isEdit
                ? "Data berhasil diperbarui"
                : "Data berhasil disimpan",
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  InputDecoration _inputStyle(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF2ECC71),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF2ECC71),
          width: 2,
        ),
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
        title: Text(
          isEdit
              ? "EDIT DATA MAHASISWA"
              : "TAMBAH DATA MAHASISWA",
          style: const TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2ECC71),
                          Color(0xFF27AE60),
                        ],
                      ),
                    ),
                    child: Icon(
                      isEdit
                          ? Icons.edit_note
                          : Icons.person_add_alt_1,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    isEdit
                        ? "FORM EDIT MAHASISWA"
                        : "FORM TAMBAH MAHASISWA",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Sistem Informasi Akademik",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: idController,
                    enabled: !isEdit,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _inputStyle(
                      "ID Mahasiswa",
                      Icons.badge_outlined,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: namaController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _inputStyle(
                      "Nama Mahasiswa",
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: prodiController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _inputStyle(
                      "Program Studi",
                      Icons.menu_book_outlined,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isEdit
                            ? Icons.update
                            : Icons.save,
                      ),
                      label: Text(
                        isEdit
                            ? "UPDATE DATA"
                            : "SIMPAN DATA",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF27AE60),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: simpan,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Faculty Information System",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Research • Education • Innovation",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}