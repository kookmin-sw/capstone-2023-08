import 'dart:convert';

import 'package:client/component/custom_snackbar.dart';
import 'package:client/component/custom_text_form_field.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/data/update_user_info.dart';
import 'package:client/layout/root_tab.dart';
import 'package:client/screen/my_page_screen.dart';
import 'package:client/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../component/one_button_dialog.dart';
import '../constant/colors.dart';
import '../dio/dio.dart';
import '../layout/default_layout.dart';

class UserInfoUpdateScreen extends ConsumerStatefulWidget {
  UserInfoUpdateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoUpdateScreen> createState() =>
      _UserInfoUpdateScreenState();
}

class _UserInfoUpdateScreenState extends ConsumerState<UserInfoUpdateScreen> {
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _nameTextEditingController = TextEditingController();

  final dio = Dio();
  final nameFormKey = GlobalKey<FormState>();
  final pwFormKey = GlobalKey<FormState>();

  bool isNameValidate = false;
  String? nameText;

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(secureStorageProvider);
    final update = UpdateUserInfo(dio: dio, storage: storage, context: context);

    Future<bool> setName() async {
      final firstName = await storage.read(key: USER_NAME);
      if (firstName == null) return false;
      _nameTextEditingController.text = firstName ?? '';
      return true;
    }

    bool textNullCheck(value) {
      if (value == null || value.isEmpty) {
        setState(() {
          nameText = '닉네임을 입력해주세요';
        });
        return true;
      }
      return false;
    }

    Future<void> isNameDuplicated() async {
      final value = _nameTextEditingController!.text;

      bool textNullCheck(value) {
        if (value == null || value.isEmpty) {
          setState(() {
            nameText = '닉네임을 입력해주세요';
          });
          return true;
        }
        return false;
      }

      if (textNullCheck(value) == true) return;

      Response response;
      try {
        response = await dio.get(
          SIGN_UP_NAME_CHECK_URL,
          data: json.encode({'user_name': value.toString()}),
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
      final value = _nameTextEditingController.text;
      if (textNullCheck(value) == true) return;

      if (value.length > 10) {
        setState(() {
          nameText = '닉네임은 10자 이하로 입력해주세요';
        });
        return;
      }

      await isNameDuplicated();
    }

    void nameChanged(value) async {
      setState(() {
        isNameValidate = false;
      });
      await nameValidator();
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
      if (value != _newPasswordController.text) {
        return '비밀번호가 입력한 문자와 일치하지 않습니다';
      }
      return null;
    }

    Future<void> onNameUpdatePressed() async {
      if (nameFormKey.currentState!.validate() && isNameValidate) {
        update.updateSomething(
            url: UPDATE_NAME_URL,
            data: {'new_username': _nameTextEditingController.text},
            isName: true);
      }
    }

    Future<void> onPwUpdatePressed() async {
      if (pwFormKey.currentState!.validate()) {
        update.updateSomething(
            url: UPDATE_PW_URL,
            data: {
              'origin_password': _passwordController.text,
              'new_password': _newPasswordController.text
            },
            isName: false);
      }
    }

    List<Widget> updateLayout = <Widget>[
      Form(
        key: nameFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '닉네임',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<Object>(
                future: setName(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == true) {
                    return CustomTextFormField(
                      validator: (val) {
                        return nameText;
                      },
                      onTextChanged: nameChanged,
                      width: MediaQuery.of(context).size.width,
                      controller: _nameTextEditingController,
                      labelText: '닉네임',
                    );
                  } else {
                    nameText = '';
                    return CustomTextFormField(
                      validator: (val) {
                        return nameText;
                      },
                      onTextChanged: nameChanged,
                      width: MediaQuery.of(context).size.width,
                      controller: _nameTextEditingController,
                      labelText: '닉네임',
                    );
                  }

                }
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: onNameUpdatePressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: PRIMARY_BLACK_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text('변경하기'),
                ),
              ),
            ],
          ),
        ),
      ),
      Form(
        key: pwFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('비밀번호 변경', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16.0),
              const Text('현재 비밀번호', style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                width: MediaQuery.of(context).size.width,
                controller: _passwordController,
                labelText: '현재 비밀번호',
                validator: pwValidator,
              ),
              const SizedBox(height: 24.0),
              const Text('신규 비밀번호', style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                width: MediaQuery.of(context).size.width,
                controller: _newPasswordController,
                labelText: '신규 비밀번호',
                validator: pwValidator,
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                width: MediaQuery.of(context).size.width,
                controller: _confirmNewPasswordController,
                labelText: '신규 비밀번호 확인',
                validator: pwConfirmValidator,
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 45.0,
                child: ElevatedButton(
                  onPressed: onPwUpdatePressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: PRIMARY_BLACK_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text('변경하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return DefaultLayout(
      title: '회원정보수정',
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: updateLayout.length,
            itemBuilder: (_, index) {
              return updateLayout[index];
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 50.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
