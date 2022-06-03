import 'gender.dart';

class User {
  final int? id;
  final String? image;
  final String name;
  final Gender gender;
  final String email;
  final int level;
  final String password;

  const User({
    this.id,
    this.image,
    required this.name,
    required this.gender,
    required this.email,
    required this.level,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      gender: Gender.values[map['gender']],
      email: map['email'],
      level: map['level'],
      password: map['password'],
    );
  }
}
