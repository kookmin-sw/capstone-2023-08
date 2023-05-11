import 'dart:convert';

import 'package:client/constant/page_url.dart';
import 'package:client/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../dio/dio.dart';
import '../secure_storage/secure_storage.dart';

// 페이지 내 상태관리 : riverpod이라는 플러그인 사용, 페이지 전체에서 secure storage 관리 가능하게 만드는 것.
// 장점 : secure storage를 어디서든 꺼내쓸수있음
// 단점 : 복잡하고 귀찮은 설정이 필요합니다..! 주석을 잘 확인해서 하나씩 변경해주세요
// 현재 : StatelessWidget인 경우, 2번까지 절차 필요
class TestScreen extends ConsumerWidget { // 1. secure storage를 받아오기 위해 ConsumerWidget으로 변경
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) { // 2. context 옆 , WidgetRef ref 추가 = 끝입니다!
    final storage = ref.watch(secureStorageProvider);

    return DefaultLayout(
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // api 요청시 붙이기 시작 -----------------------------------------------
                final dio = Dio(
                  BaseOptions(
                    headers: {'accessToken': 'true'}, // accessToken이 필요하다는 뜻
                  ),
                );

                dio.interceptors.add(
                  CustomInterceptor(storage: storage),
                );
                // api 요청시 붙이기 끝 -----------------------------------------------

                Response response;
                try {
                  response = await dio.get(
                    LIST_URL,
                  );
                  print(response.data['data']);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('쇼핑몰 리스트 띄워주기'),
            ),
          ],
        ),
      ),
    );
  }
}
