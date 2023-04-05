import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class SignupFormData {
  String? id;
  String? password;
  String? nickname;
  // String? img;

  SignupFormData({this.id, this.password, this.nickname});

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'user_name': nickname,
        'password': password,
        // 'user_img_url': img
      };
}

class _SignUpPageState extends State<SignUpScreen> {
  FocusNode myFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  SignupFormData formData = SignupFormData();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // myFocusNode에 포커스 인스턴스 저장.
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                key: ValueKey(1),
                //controller: _emailController,
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.black : Colors.grey),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.grey),
                  // ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                //style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                onChanged: (value) {
                  formData.id = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                key: ValueKey(2),
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.black : Colors.grey),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.grey),
                  // ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: Colors.black,
                ),
                obscureText: true,
                cursorColor: Colors.black,
                onChanged: (value) {
                  formData.password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.black : Colors.grey),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.grey),
                  // ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                key: ValueKey(3),
                //controller: _emailController,
                // focusNode: myFocusNode,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.black : Colors.grey),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.grey),
                  // ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                //style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                onChanged: (value) {
                  formData.nickname = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Nickname';
                  }
                  return null;
                },
              ),

              // SizedBox(height: 16.0),
              // TextFormField(
              //   key: ValueKey(4),
              //   //controller: _emailController,
              //   // focusNode: myFocusNode,
              //   decoration: InputDecoration(
              //     labelText: '이미지 url',
              //     labelStyle: TextStyle(
              //         color: myFocusNode.hasFocus ? Colors.black : Colors.grey),
              //     // enabledBorder: UnderlineInputBorder(
              //     //     borderSide: BorderSide(color: Colors.grey),
              //     // ),
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.black),
              //     ),
              //   ),
              //   //style: TextStyle(color: Colors.black),
              //   cursorColor: Colors.black,
              // ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var result = await http.post(
                        Uri.parse('http://10.0.2.2:8000/'),
                        body: json.encode(formData.toJson()),
                        headers: {'content-type': 'application/json'});
                    if (result.statusCode == 201) {
                      _showDialog('Successfully signed up');
                    } else {
                      _showDialog('Failed to sign up');
                    }
                  }
                },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50),
                  primary: Colors.black, // Background color
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  
}
