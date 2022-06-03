import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {
  final _loggedIn = BehaviorSubject<bool>();
  Stream<bool> get loggedIn => _loggedIn.stream;
  StreamSink<bool> get _loggedInSink => _loggedIn.sink;

  final _signedUp = BehaviorSubject<bool>();
  Stream<bool> get signedUp => _signedUp.stream;
  StreamSink<bool> get _signedUpSink => _signedUp.sink;

  void dispose() {
    _loggedIn.close();
  }

  Future<void> checkLogin() async {
    final loggedInPref =
        (await SharedPreferences.getInstance()).getBool('loggedIn');
    _loggedInSink.add(loggedInPref ?? false);
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('http://192.168.1.27:80/listprodcut/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      (await SharedPreferences.getInstance()).setBool('loggedIn', true);
      _loggedInSink.add(true);
    } else {
      _loggedInSink.add(false);
    }
  }

  Future<void> signUp(Map<String, dynamic> user) async {
    final url = Uri.parse('http://192.168.1.27:80/listprodcut/');
    final response = await http.post(url, body: jsonEncode(user));

    _signedUpSink.add(response.statusCode == 200);
  }

  Future<void> signOut() async {
    (await SharedPreferences.getInstance()).remove('isLoggedIn');
  }
}
