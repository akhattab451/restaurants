import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../helpers/database_helper.dart';
import '../models/load_state.dart';
import '../models/user.dart';

class AuthService {
  final DatabaseHelper helper;
  const AuthService({required this.helper});

  Future<User?> get user async {
    final userString =
        (await SharedPreferences.getInstance()).getString('user');

    if (userString == null) return null;
    return User.fromMap(jsonDecode(userString));
  }

  Future<LoadState<User?>> signIn(String email, String password) async {
    final db = await helper.database;
    final userList = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (userList.isEmpty) {
      return const LoadState(message: 'Invalid credintials');
    }

    (await SharedPreferences.getInstance())
        .setString('user', jsonEncode(userList.first));

    return LoadState(data: User.fromMap(userList.first));
  }

  Future<LoadState<int?>> signUp(Map<String, dynamic> user) async {
    final db = await helper.database;
    final userList = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user['email']],
      limit: 1,
    );

    if (userList.isNotEmpty) {
      return const LoadState(message: 'Email already exists.');
    }

    final id = await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return LoadState(data: id);
  }

  Future<void> signOut() async {
    (await SharedPreferences.getInstance()).remove('user');
  }

  Future<void> updateImage(String path, int userId) async {
    final db = await helper.database;
    await db.update(
      'users',
      {'image': path},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
