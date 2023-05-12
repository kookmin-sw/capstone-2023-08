import 'dart:convert';
<<<<<<< HEAD
<<<<<<< HEAD
=======
import '../data/account.dart';
=======

import 'package:camera/camera.dart';
import 'package:client/component/one_button_dialog.dart';
import 'package:client/constant/colors.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/screen/camera_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../component/custom_text_form_field.dart';
import '../data/account_model.dart';
>>>>>>> upstream/Frontend
import '../layout/default_layout.dart';
>>>>>>> upstream/Frontend

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

<<<<<<< HEAD
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
=======
class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode myFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
<<<<<<< HEAD
  Account formData = Account();
>>>>>>> upstream/Frontend
  final _emailController = TextEditingController();
=======
  AccountModel userInfo = AccountModel();
  final _idController = TextEditingController();
>>>>>>> upstream/Frontend
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool isIdValidate = false;
  String validateText = '중복확인';

  @override
  void initState() {
    super.initState();
    // myFocusNode에 포커스 인스턴스 저장.
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    void onIdChanged(value) {
      userInfo.user_id = value;
      userInfo.user_img_url = value + "_human.png";
      setState(() {
        isIdValidate = false;
        validateText = '중복확인';
      });
    }

    String? idValidator(value) {
      if (value == null || value.isEmpty) {
        return '아이디를 입력해주세요';
      }
      // validate string이 아니면 제외.
      final validStr = RegExp(r'[A-Za-z0-9]$');
      if (!validStr.hasMatch(value)) {
        return '아이디는 알파벳, 숫자만 사용할 수 있습니다';
      }

      if (isIdValidate == false) {
        return '아이디 중복확인 후 회원가입 해주세요';
      }
      return null;
    }

    void onpwChanged(value) {
      userInfo.password = value;
    }

    String? pwValidator(value) {
      if (value == null || value.isEmpty) {
        return '비밀번호를 입력해주세요';
      }
      if (value.length < 6) {
        return '비밀번호는 최소 6자 이상 입력해야 합니다';
      }

      // validate string이 아니면 제외.
      final validStr = RegExp(r'[A-Za-z0-9!@#$%^_]$');
      print('[pw] $value is valid? ${validStr.hasMatch(value)}');
      if (!validStr.hasMatch(value)) {
        return '알파벳, 숫자, 특수문자(!@#\$%^_)만 사용할 수 있습니다';
      }
      return null;
    }

    String? pwConfirmValidator(value) {
      if (value == null || value.isEmpty) {
        return '비밀번호 확인 문자를 입력해주세요';
      }
      if (value != _passwordController.text) {
        return '비밀번호가 입력한 문자와 일치하지 않습니다';
      }
      return null;
    }

    void nickNameChanged(value) {
      userInfo.user_name = value;
    }

    String? nickNameValidator(value) {
      if (value == null || value.isEmpty) {
        return '닉네임을 입력해주세요';
      }
      if (value.length > 10) {
        return '닉네임은 10자 이하로 입력해주세요';
      }
      return null;
    }

    bool isValid() {
      return (_idController.text.length > 0) &&
          (_passwordController.text.length > 0) &&
          (_confirmPasswordController.text.length > 0) &&
          (_nicknameController.text.length > 0) &&
          isIdValidate;
    }

    return DefaultLayout(
      title: '회원가입',
<<<<<<< HEAD
      child: Padding(
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
<<<<<<< HEAD
=======
                  formData.img = value + ".jpg";
>>>>>>> upstream/Frontend
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
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
              SizedBox(height: 8.0),
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
<<<<<<< HEAD
              SizedBox(height: 16.0),
=======
              SizedBox(height: 8.0),
>>>>>>> upstream/Frontend
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
<<<<<<< HEAD
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
=======
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
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // _showDialog(formData.toJson());
                      var result = await http.post(
                        Uri.parse('http://35.84.85.252:8000/account/sign-up'),
                        body: json.encode(formData.toJson()),
                      );
                      if (result.statusCode == 200) {
                        final response = await http.get(Uri.parse(
                            'http://35.84.85.252:8000/account/sign-up'));
                        print(response.body);
                        //_showDialog(json.decode(response.body));
                      } else {
                        _showDialog('Failed to sign up');
                      }
                    }
                  },
                  child: Text('촬영하고 회원가입하기'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(80, 25),
                    primary: Colors.black, // Background color
                    alignment: Alignment.center,
                  ),
>>>>>>> upstream/Frontend
=======
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: width,
            height: height * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextFormField(
                            width: width * 0.6,
                            key: ValueKey(1),
                            focusNode: myFocusNode,
                            controller: _idController,
                            labelText: '아이디',
                            onTextChanged: onIdChanged,
                            validator: idValidator,
                            textInputAction: TextInputAction.next,
                            isFocused: myFocusNode.hasFocus,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: 70.0,
                            height: 45.0,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: PRIMARY_BLACK_COLOR,
                              ),
                              onPressed: () async {
                                // id = null인 경우 요청 전송 x
                                if (_idController.text.isEmpty) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return OneButtonDialog(
                                        title: '아이디를 입력해주세요',
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                }

                                final dio = Dio();
                                print(_idController.text);
                                Response response;
                                try {
                                  response = await dio.get(
                                    SIGN_UP_URL,
                                    data: json.encode(
                                        {'user_id': _idController.text.toString()}),
                                  );
                                  if (response.statusCode == 205) {
                                  } else {
                                    setState(() {
                                      isIdValidate = true;
                                      validateText = '✔';
                                    });
                                  }
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return OneButtonDialog(
                                        title: response.data['message'],
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text(
                                validateText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: ValueKey(2),
                      width: width,
                      controller: _passwordController,
                      labelText: '비밀번호',
                      obscureText: true,
                      onTextChanged: onpwChanged,
                      validator: pwValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      width: width,
                      controller: _confirmPasswordController,
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      validator: pwConfirmValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: ValueKey(3),
                      width: width,
                      controller: _nicknameController,
                      labelText: '닉네임',
                      onTextChanged: nickNameChanged,
                      validator: nickNameValidator,
                    ),
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: /*isValid()
                            ? */() async {
                                if (_formKey.currentState!.validate() &&
                                    isIdValidate) {
                                  print('camera start');
                                  List<CameraDescription> cameras =
                                      await availableCameras();

                                  print('available camera ${cameras.isEmpty}');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => CameraScreen(
                                          cameras: cameras,
                                          userInfo: userInfo)));
                                }
                              }
                            /*: null*/,
                        child: Text('촬영하고 회원가입하기'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: Size(80, 25),
                          backgroundColor: PRIMARY_BLACK_COLOR,
                          alignment: Alignment.center,
                          disabledBackgroundColor: Colors.grey,
                          disabledForegroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
>>>>>>> upstream/Frontend
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> upstream/Frontend
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
<<<<<<< HEAD

  
=======
>>>>>>> upstream/Frontend
=======
>>>>>>> upstream/Frontend
}
