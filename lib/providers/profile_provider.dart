import 'package:flutter/material.dart';
import '../helpers/db_helper.dart'; // jangan lupa ini!
import '../models/profile.dart';

class ProfileProvider with ChangeNotifier {
  List<Profile> _profiles = [];
  List<Profile> get profiles => _profiles;

  Profile _myProfile = Profile(
    name: 'Handy Jawady',
    phone: '+6281337136811',
    profilePhoto: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZibSdE0oAQK60bhgOwqNxht_vUGGbgYUtYA&s',
    coverPhoto: 'https://picsum.photos/600/200?xrandom=25',
    quote:
        '“mmx.”',
  );
  Profile get myProfile => _myProfile;

  void updateMyProfile(Profile profile) {
    _myProfile = profile;
    notifyListeners();
  }

  Future<void> fetchProfiles() async {
    final db = await DBHelper.database;
    final data = await db.query('profiles');
    _profiles = data.map((item) => Profile.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    final db = await DBHelper.database;
    final id = await db.insert('profiles', profile.toMap());
    _profiles.add(
      Profile(
        id: id,
        name: profile.name,
        phone: profile.phone,
        profilePhoto: profile.profilePhoto,
        coverPhoto: profile.coverPhoto,
        quote: profile.quote,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProfile(int id, Profile profile) async {
    final db = await DBHelper.database;
    await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchProfiles();
  }

  Future<void> deleteProfile(int id) async {
    final db = await DBHelper.database;
    await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
    _profiles.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
