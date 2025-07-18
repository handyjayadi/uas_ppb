import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile.dart';
import '../providers/profile_provider.dart';
import 'edit_profile.dart';

class DetailProfile extends StatelessWidget {
  final Profile profile;
  const DetailProfile({super.key, required this.profile});

  final List<String> gallery = const [
    "https://picsum.photos/200?1",
    "https://picsum.photos/200?2",
    "https://picsum.photos/200?3",
    "https://picsum.photos/200?4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Detail Profil"),
        backgroundColor: const Color.fromARGB(255, 0, 137, 103),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          final currentProfile = profile.id == null
              ? provider.myProfile
              : provider.profiles.firstWhere(
                  (p) => p.id == profile.id,
                  orElse: () => profile,
                );

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentProfile.coverPhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -70,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(currentProfile.profilePhoto),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                Text(
                  currentProfile.name,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Hubungi',
                      onPressed: () async {
                        final Uri telUri = Uri(scheme: 'tel', path: currentProfile.phone);
                        if (await canLaunchUrl(telUri)) {
                          await launchUrl(telUri);
                        }
                      },
                      icon: Icon(Icons.call, color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    IconButton(
                      tooltip: 'Email',
                      onPressed: () {},
                      icon: Icon(Icons.email, color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    IconButton(
                      tooltip: 'Bagikan',
                      onPressed: () {},
                      icon: Icon(Icons.share, color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1.2),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            "Kata-kata Hari Ini",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "\"${currentProfile.quote}\"",
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Galeri",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: gallery.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  gallery[index],
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
               
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Kembali"),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 253, 254, 1),
                      ),
                      onPressed: () async {
                        final updatedProfile = await Navigator.push<Profile>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(profile: currentProfile),
                          ),
                        );
                        if (updatedProfile != null) {
                          if (currentProfile.id == null) {
                            provider.updateMyProfile(updatedProfile);
                          } else {
                            await provider.updateProfile(
                              currentProfile.id!,
                              updatedProfile,
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Profil diperbarui")),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profil"),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
