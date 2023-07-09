import 'package:get_it/get_it.dart';
import 'package:magcloud_app/core/service/friend_diary_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/api/api_interceptor.dart';
import 'core/api/open_api.dart';
import 'core/repository/diary_repository.dart';
import 'core/service/auth_service.dart';
import 'core/service/diary_service.dart';
import 'core/service/online_service.dart';
import 'package:dio/dio.dart';

import 'core/service/user_service.dart';

final inject = GetIt.instance;

Future<void> initializeDependencies() async {
  final packageInfo = await PackageInfo.fromPlatform();
  inject.registerSingleton(packageInfo);

  //final dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.49:9999/api'));
  final dio = Dio(BaseOptions(baseUrl: 'https://magcloud.chuyong.kr/api'));
  inject.registerSingleton(dio);
  //final client = OpenAPI(dio, baseUrl: 'https://magcloud.chuyong.kr/api/v1');
  final client = OpenAPI(dio);

  inject.registerSingleton(client);
  final authService = AuthService();
  inject.registerSingleton(authService);

  dio.interceptors.add(ApiInterceptor());

  final diary = await DiaryRepository.create();
  inject.registerSingleton(diary);
  final onlineService = OnlineService();
  inject.registerSingleton(onlineService);
  inject.registerSingleton(DiaryService(onlineService, diary));
  inject.registerSingleton(FriendDiaryService(onlineService));
  inject.registerSingleton(UserService());
}
