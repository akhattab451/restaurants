import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gender.dart';
import '../services/auth_service.dart';
import '../util.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/sign_up';
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{'level': 1};
  final _passwordController = TextEditingController();

  Gender? _gender = Gender.male;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          'Register New Account',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 30.0),
            const Text('Name'),
            const SizedBox(height: 4.0),
            TextFormField(
              onSaved: (String? newValue) {
                _formData['name'] = newValue;
              },
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Required field.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            const Text('Gender:'),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Male'),
                    horizontalTitleGap: 0.0,
                    leading: Radio<Gender>(
                      value: Gender.male,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() => _gender = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListTile(
                    title: const Text('Female'),
                    horizontalTitleGap: 0.0,
                    leading: Radio<Gender>(
                      value: Gender.female,
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() => _gender = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Text('Email'),
            const SizedBox(height: 4.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSaved: (String? newValue) {
                _formData['email'] = newValue;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Required field.';
                }
                if (!validEmail(value)) {
                  return 'Invalid e-mail.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            const Text('Level'),
            const SizedBox(height: 4.0),
            DropdownButtonFormField(
              value: _formData['level'] as int?,
              isDense: true,
              items: List.generate(
                4,
                (index) {
                  return DropdownMenuItem<int>(
                    child: Text('${index + 1}'),
                    value: index + 1,
                  );
                },
              ),
              onChanged: (int? newValue) {
                _formData['level'] = newValue;
              },
            ),
            const SizedBox(height: 8.0),
            const Text('Password'),
            const SizedBox(height: 4.0),
            TextFormField(
              obscureText: true,
              textInputAction: TextInputAction.next,
              controller: _passwordController,
              onSaved: (String? newValue) {
                _formData['password'] = newValue;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Required field.';
                }
                if (value.length < 8) {
                  return 'Password can\'t be less than 8 characters.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            const Text('Confirm Password'),
            const SizedBox(height: 4.0),
            TextFormField(
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Required field.';
                }
                if (value != _passwordController.text) {
                  return 'Passwords don\'t match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _formData['gender'] = _gender?.index;
                    final state = await Provider.of<AuthService>(
                      context,
                      listen: false,
                    ).signUp(_formData);
                    if (state.data == null) {
                      showAlertDialog(
                        context,
                        message: state.message!,
                      );
                    } else {
                      showSnackbar(
                        context,
                        message: 'Sign up successful!',
                      );
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
