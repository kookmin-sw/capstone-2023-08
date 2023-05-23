import 'dart:convert';
<<<<<<< HEAD
<<<<<<< HEAD
=======
import '../data/account.dart';
=======

import 'package:client/constant/colors.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/screen/onboarding_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../component/custom_text_form_field.dart';
<<<<<<< HEAD
import '../data/account_model.dart';
>>>>>>> upstream/Frontend
import '../layout/default_layout.dart';
>>>>>>> upstream/Frontend
=======
import '../data/user_model.dart';
import '../layout/default_layout.dart';
import '../secure_storage/secure_storage.dart';
>>>>>>> upstream/Frontend

class SignUpScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

<<<<<<< HEAD
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
=======
class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();
  UserModel userInfo = UserModel();
>>>>>>> upstream/Frontend
  final _idController = TextEditingController();
>>>>>>> upstream/Frontend
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool isIdValidate = false;
  String? idText;
  bool isNameValidate = false;
  String? nameText;

  @override
  void initState() {
    super.initState();
    // myFocusNode에 포커스 인스턴스 저장.
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
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

    bool textNullCheck(value, String category) {
      if (value == null || value.isEmpty) {
        setState(() {
          switch (category) {
            case '아이디' : idText = '$category를 입력해주세요'; break;
            case '닉네임' : nameText = '$category를 입력해주세요'; break;
          }
        });
        return true;
      }
      return false;
    }

    Future<void> isIdDuplicated() async {
      final dio = Dio();
      final value = _idController.text;

      if (textNullCheck(value, '아이디') == true) return;

      Response response;
      try {
        response = await dio.get(
          SIGN_UP_ID_CHECK_URL,
          data: json.encode(
              {'user_id': value.toString()}),
        );

        if (response.statusCode == 205) {
          setState(() {
            idText = '중복되는 아이디가 있습니다. 다른 아이디로 시도해주세요';
          });
        } else {
          setState(() {
            isIdValidate = true;
            idText = null;
          });
          print('아이디 중복 x');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> idValidator() async {
      final value = _idController.text;
      if (textNullCheck(value, '아이디') == true) return;

      // validate string이 아니면 제외.
      final validStr = RegExp(r'[A-Za-z0-9]$');
      if (!validStr.hasMatch(value)) {
        setState(() {
          idText = '아이디는 알파벳, 숫자만 사용해주세요';
          print(idText);
        });
        return;
      }

      await isIdDuplicated();
    }

    void onIdChanged(value) async {
      userInfo.user_id = value;

      // 모든 validation check 수행 = isIdValidate, 그거 초기화
      setState(() {
        isIdValidate = false;
      });

      await idValidator();
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

    Future<void> isNameDuplicated() async {
      final dio = Dio();
      final value = _nicknameController.text;

      if (textNullCheck(value, '닉네임') == true) return;

      Response response;
      try {
        response = await dio.get(
          SIGN_UP_NAME_CHECK_URL,
          data: json.encode(
              {'user_name': value.toString()}),
        );

        if (response.statusCode == 205) {
          setState(() {
            nameText = '중복되는 닉네임이 있습니다. 다른 닉네임으로 시도해주세요';
          });
        } else {
          setState(() {
            isNameValidate = true;
            nameText = null;
          });
          print('닉네임 중복 x');
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> nameValidator() async {
      final value = _nicknameController.text;
      if (textNullCheck(value, '닉네임') == true) return;

      if (value.length > 10) {
        setState(() {
          nameText = '닉네임은 10자 이하로 입력해주세요';
        });
        return;
      }

      await isNameDuplicated();
    }

    void nameChanged(value) async {
      userInfo.user_name = value;

      setState(() {
        isNameValidate = false;
      });

      await nameValidator();
    }

    Future<bool> requestSignUp() async {
      Response response;
      try {
        response = await dio.post(
          SIGN_UP_URL,
          data: json.encode(userInfo.toJson()),
        );
        print(response.data);

        if (response.statusCode == 200) {
          response = await dio.get(SIGN_UP_URL);
          print(response.data);
          return true;
        } else {
          print(response.data);
          print(response.statusCode);
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<void> requestSignin () async {
      final String? id = userInfo.user_id;
      final String? pw = userInfo.password;

      final rawString = '${id}:${pw}';
      print(rawString);

      Codec<String, String> stringToBase64 = utf8.fuse(base64); // encoding 방식 정의

      String token = stringToBase64.encode(rawString); // 어떤걸 encoding 할지 정의

      final Dio dio = Dio();

      Response resp;
      String refreshToken;
      String accessToken;
      try {
        resp = await dio.post(
          SIGN_IN_URL,
          options: Options(
            headers: {
              'Authorization': 'Basic $token',
            },
          ),
          data: json.encode({
            'user_id': id,
            'password': pw,
          }),
        );

        refreshToken = resp.data['jwt_token']['refresh_token'];
        accessToken = resp.data['jwt_token']['access_token'];

        final storage = ref.read(secureStorageProvider);

        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        await storage.write(key: USER_NAME, value: resp.data['User']['user_name']);
        await storage.write(key: USER_ID, value: resp.data['User']['user_id']);
        await storage.write(key: FIRST_LOGIN, value: 'true');

        print('로그인 완료');
      } catch (e) {
        print(e);
      }
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
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextFormField(
                      width: width,
                      key: const ValueKey(1),
                      controller: _idController,
                      labelText: '아이디',
                      onTextChanged: onIdChanged,
                      validator: (val) {return idText;},
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: const ValueKey(2),
                      width: width,
                      controller: _passwordController,
                      labelText: '비밀번호',
                      obscureText: true,
                      onTextChanged: onpwChanged,
                      validator: pwValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      width: width,
                      controller: _confirmPasswordController,
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      validator: pwConfirmValidator,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 24.0),
                    CustomTextFormField(
                      key: const ValueKey(3),
                      width: width,
                      controller: _nicknameController,
                      labelText: '닉네임',
                      onTextChanged: nameChanged,
                      validator: (val) {return nameText;},
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    isIdValidate && isNameValidate) {
                                  await requestSignUp();
                                  await requestSignin();

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => const OnBoardingPage()));
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          minimumSize: const Size(80, 25),
                          backgroundColor: PRIMARY_BLACK_COLOR,
                          alignment: Alignment.center,
                        ),
                        child: const Text('회원가입하기'),
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
=======
}
>>>>>>> upstream/Frontend
