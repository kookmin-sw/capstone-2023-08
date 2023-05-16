import 'package:client/component/custom_text_form_field.dart';
import 'package:client/constant/page_url.dart';
import 'package:client/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant/colors.dart';
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
  final nameTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = ref.watch(secureStorageProvider);
      final first_name = await storage.read(key: USER_NAME);
      nameTextEditingController.text = first_name?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> updateLayout = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '닉네임',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            CustomTextFormField(
              width: MediaQuery.of(context).size.width,
              controller: nameTextEditingController,
              labelText: '닉네임',
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('저장'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: PRIMARY_BLACK_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비밀번호 변경', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 16.0),
            Text('현재 비밀번호'),
            SizedBox(height: 8.0),
            CustomTextFormField(
              width: MediaQuery.of(context).size.width,
              controller: _passwordController,
              labelText: '현재 비밀번호',
            ),
            SizedBox(height: 16.0),
            Text('신규 비밀번호'),
            SizedBox(height: 8.0),
            CustomTextFormField(
              width: MediaQuery.of(context).size.width,
              controller: _newPasswordController,
              labelText: '신규 비밀번호',
            ),
            SizedBox(height: 8.0),
            CustomTextFormField(
              width: MediaQuery.of(context).size.width,
              controller: _confirmNewPasswordController,
              labelText: '신규 비밀번호 확인',
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('변경하기'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: PRIMARY_BLACK_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.white,
                ),
              ),
            ),
          ],
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
              itemCount: updateLayout.length,
              itemBuilder: (_, index) {
                return updateLayout[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 50.0, color: BUTTON_BORDER_COLOR)),
        ),
      ),
    );
  }
}
