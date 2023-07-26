import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:magcloud_app/core/service/friend_diary_service.dart';
import 'package:magcloud_app/core/service/notification_service.dart';
import 'package:magcloud_app/core/service/tag_resolver.dart';
import 'package:magcloud_app/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'core/api/api_interceptor.dart';
import 'core/api/open_api.dart';
import 'core/repository/diary_repository.dart';
import 'core/service/auth_service.dart';
import 'core/service/diary_service.dart';
import 'core/service/online_service.dart';
import 'core/service/user_service.dart';

final inject = GetIt.instance;

Future<void> initializeDependencies() async {
  // 내 영역 밖의 디펜던시
  final packageInfo = await PackageInfo.fromPlatform();
  inject.registerSingleton(packageInfo);

  final dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
  inject.registerSingleton(dio);

  final client = OpenAPI(dio);
  inject.registerSingleton(client);

  // 여기부터 내꺼
  final notificationService = NotificationService();
  inject.registerSingleton(notificationService);

  final authService = AuthService(openApi: client, notificationService: notificationService);
  inject.registerSingleton(authService);

  dio.interceptors.add(ApiInterceptor(authService: authService, dio: dio, packageInfo: packageInfo));

  final diary = await DiaryRepository.create();
  inject.registerSingleton(diary);

  final onlineService = OnlineService(openAPI: client);
  inject.registerSingleton(onlineService);

  final diaryService = DiaryService(onlineService: onlineService, diaryRepository: diary);
  inject.registerSingleton(diaryService);

  final friendDiaryService = FriendDiaryService(onlineService: onlineService, openAPI: client);
  inject.registerSingleton(friendDiaryService);

  final userService = UserService(onlineService: onlineService, openAPI: client);
  inject.registerSingleton(userService);

  final tagService = TagResolver(openAPI: client);
  inject.registerSingleton(tagService);



  await notificationService.initializeNotification();
  await authService.initialize();
  try {
    await tagService.loadFriends();
  }catch(e) {

  }
}
