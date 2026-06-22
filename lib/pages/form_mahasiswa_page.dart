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

    final response = await http.get(Uri.parse(url));
    print(response.body);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Mahasiswa" : "Tambah Mahasiswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idController,
              enabled: !isEdit,
              decoration: const InputDecoration(labelText: "ID"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: prodiController,
              decoration: const InputDecoration(labelText: "Prodi"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: simpan,
              child: Text(isEdit ? "Update" : "Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}