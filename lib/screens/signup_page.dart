import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noot_app/screens/home_page.dart';
import '../auth.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final bool _isLogin = false;
  bool _passwordVisible = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _hiddenPasswordController = TextEditingController();

  handleSubmit() async {
    setState(() => _isLoading = true);
    if (_passwordController == 0) {
      displayMessage("Please enter password");
    } else if (_passwordController.text != _hiddenPasswordController.text) {
      displayMessage("Passwords don't match!");
    } else {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text);
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          print(e.code);
        }

    }
    setState(() => _isLoading = false);
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[150],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_rounded,
              size: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Create an account",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.w800),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: 'Email',
                  focusColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      )
                  )
              ),
            ),
            const SizedBox(
                height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility: Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  focusColor: Colors.black,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      )
                  )
              ),
            ),
            const SizedBox(
                height: 16.0),
            TextFormField(
              controller: _hiddenPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Confirm password',
                  focusColor: Colors.black,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      )
                  )
              ),
            ),
            const SizedBox(height: 18.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
              // sign in call
                handleSubmit();
                },

              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text('Sign up'),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () async { // Go back to login page
                    _passwordVisible = false;
                    Navigator.pop(context);
                  },
                  child: Text('Login here'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}