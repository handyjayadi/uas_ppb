import 'package:flutter/material.dart';
import '../models/profile.dart';

class EditProfile extends StatefulWidget {
  final Profile profile;
  const EditProfile({super.key, required this.profile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController profilePhotoController;
  late TextEditingController coverPhotoController;
  late TextEditingController quoteController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController = TextEditingController(text: widget.profile.phone);
    profilePhotoController = TextEditingController(text: widget.profile.profilePhoto);
    coverPhotoController = TextEditingController(text: widget.profile.coverPhoto);
    quoteController = TextEditingController(text: widget.profile.quote);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    profilePhotoController.dispose();
    coverPhotoController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal[600]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Nama", Icons.person),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: _inputDecoration("No HP", Icons.phone),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: profilePhotoController,
                  decoration: _inputDecoration("URL Foto Profil", Icons.image),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: coverPhotoController,
                  decoration: _inputDecoration("URL Cover Photo", Icons.photo),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quoteController,
                  decoration: _inputDecoration("Quote", Icons.format_quote),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final updated = Profile(
                        id: widget.profile.id,
                        name: nameController.text,
                        phone: phoneController.text,
                        profilePhoto: profilePhotoController.text,
                        coverPhoto: coverPhotoController.text,
                        quote: quoteController.text,
                      );
                      Navigator.pop(context, updated);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Profil"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
