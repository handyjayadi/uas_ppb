import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../screens/detail_profile.dart';
import '../models/profile.dart';

const List<String> namaAcak = [
  "Andi", "Budi", "Citra", "Dewi", "Eka", "Fajar",
  "Gita", "Hadi", "Intan", "Joko", "Kirana", "Lestari"
];

const List<String> quotes = [
  "Hidup adalah perjalanan, bukan tujuan.",
  "Jangan takut gagal, takutlah untuk tidak mencoba.",
  "Kamu lebih kuat dari yang kamu kira.",
  "Bahagia itu sederhana.",
  "Percaya proses.",
  "Jadilah versi terbaik dirimu.",
  "Senyum adalah kekuatanmu.",
  "Lakukan dengan hati.",
  "Setiap hari adalah awal yang baru.",
  "Bersyukurlah atas hal-hal kecil.",
];

class ListProfile extends StatefulWidget {
  const ListProfile({super.key});

  @override
  State<ListProfile> createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final profiles = profileProvider.profiles;

          if (profiles.isEmpty) {
            return const Center(
              child: Text("Belum ada data profil."),
            );
          }

          return ListView.builder(
            itemCount: profiles.length,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final profile = profiles[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profile.profilePhoto),
                  ),
                  title: Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    profile.quote ?? profile.phone,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await profileProvider.deleteProfile(profile.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profil dihapus")),
                      );
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailProfile(profile: profile),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final provider =
              Provider.of<ProfileProvider>(context, listen: false);

          final randomName = namaAcak[_random.nextInt(namaAcak.length)];
          final randomQuote = quotes[_random.nextInt(quotes.length)];
          final randomNumber = _random.nextInt(100);

          final newProfile = Profile(
            name: randomName,
            phone: "+62812${10000 + randomNumber}",
            profilePhoto: "https://i.pravatar.cc/150?img=$randomNumber",
            coverPhoto: "https://picsum.photos/600/200?random=$randomNumber",
            quote: randomQuote,
            id: null,
          );

          await provider.addProfile(newProfile);
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Mahasiswa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil Saya",
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  final myProfile =
                      context.read<ProfileProvider>().myProfile;
                  return DetailProfile(profile: myProfile);
                },
              ),
            );
            if (result != null && result is Profile) {
              context.read<ProfileProvider>().updateMyProfile(result);
            }
          }
        },
      ),
    );
  }
}
