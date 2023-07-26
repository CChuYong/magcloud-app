import 'package:dio/dio.dart';
import 'package:magcloud_app/core/api/dto/auth_request.dart';
import 'package:magcloud_app/core/api/dto/auth_response.dart';
import 'package:magcloud_app/core/api/dto/count_response.dart';
import 'package:magcloud_app/core/api/dto/device_request.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_integrity_response.dart';
import 'package:magcloud_app/core/api/dto/diary/diary_update_request.dart';
import 'package:magcloud_app/core/api/dto/feed/feed_response.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_accept_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_request.dart';
import 'package:magcloud_app/core/api/dto/friend/friend_response.dart';
import 'package:magcloud_app/core/api/dto/image_upload_response.dart';
import 'package:magcloud_app/core/api/dto/profile_image_update_request.dart';
import 'package:magcloud_app/core/api/dto/user_nickname_request.dart';
import 'package:magcloud_app/core/api/dto/user_response.dart';
import 'package:retrofit/http.dart';

import 'dto/api_response.dart';
import 'dto/auth_refresh_request.dart';
import 'dto/diary/diary_comment_request.dart';
import 'dto/diary/diary_comment_response.dart';
import 'dto/diary/diary_request.dart';
import 'dto/diary/diary_response.dart';
import 'dto/friend/daily_user_response.dart';
import 'dto/notification_request.dart';

part 'open_api.g.dart';

@RestApi()
abstract class OpenAPI {
  factory OpenAPI(Dio dio, {String baseUrl}) = _OpenAPI;

  @GET('/health-check')
  Future<dynamic> onlineCheck();

  @POST('/v1/auth')
  Future<AuthResponse> authenticate(@Body() AuthRequest request);

  @POST('/v1/auth/refresh')
  Future<AuthResponse> refresh(@Body() AuthRefreshRequest request);

  @GET('/v1/users/me')
  Future<UserResponse> getMyProfile();

  @GET('/v1/users/{userId}')
  Future<UserResponse> getUserProfile(@Path() String userId);

  @POST('/v1/users/device')
  Future<APIResponse> registerDevice(@Body() DeviceRequest request);

  @POST('/v1/users/leave')
  Future<APIResponse> leaveMagCloud();

  @DELETE('/v1/users/device')
  Future<APIResponse> unRegisterDevice(@Body() DeviceRequest request);

  @GET('/v1/users/me/image-request')
  Future<ImageUploadResponse> getImageRequest();

  @POST('/v1/users/me/profile-image')
  Future<dynamic> updateProfileImage(@Body() ProfileImageUpdateRequest request);

  @POST('/v1/users/me/name')
  Future<UserResponse> updateNickname(@Body() UserNickNameRequest request);

  @GET('/v1/users/notification')
  Future<NotificationRequest> getNotificationConfig();

  @PATCH('/v1/users/notification')
  Future<NotificationRequest> updateNotificationConfig(
      @Body() NotificationRequest request);

  @GET('/v1/users/friends')
  Future<List<FriendResponse>> getFriends();

  @GET('/v1/users/friends/daily')
  Future<List<DailyUserResponse>> getDailyFriends();

  @PATCH('/v1/users/friends/shareable')
  Future<APIResponse> shareDiary(@Body() FriendAcceptRequest request);

  @PATCH('/v1/users/friends/unshareable')
  Future<APIResponse> unShareDiary(@Body() FriendAcceptRequest request);

  @GET('/v1/users/friends/requests')
  Future<List<UserResponse>> getFriendRequests();

  @GET('/v1/users/friends/requests/count')
  Future<CountResponse> getFriendRequestsCount();

  @GET('/v1/users/friends/requests/sent')
  Future<List<UserResponse>> getSentFriendRequests();

  @POST('/v1/users/friends/requests')
  Future<APIResponse> requestFriend(@Body() FriendRequest request);

  @POST('/v1/users/friends/requests/accept')
  Future<APIResponse> acceptFriendRequest(@Body() FriendAcceptRequest request);

  @POST('/v1/users/friends/requests/deny')
  Future<APIResponse> denyFriendRequest(@Body() FriendAcceptRequest request);

  @POST('/v1/users/friends/requests/cancel')
  Future<APIResponse> cancelFriendRequest(@Body() FriendAcceptRequest request);

  @POST('/v1/users/friends/break')
  Future<APIResponse> breakFriend(@Body() FriendAcceptRequest request);

  @GET('/v1/diaries')
  Future<DiaryResponse> getDiaryByDate(@Query("date") String date);

  @GET('/v1/diaries/{diaryId}/integrity')
  Future<DiaryIntegrityResponse> getDiaryIntegrity(
      @Path('diaryId') String diaryId);

  @GET('/v1/diaries/integrity')
  Future<List<DiaryIntegrityResponse>> getDiaryIntegrityByMonth(
      @Query("year") int year, @Query("month") int month);

  @GET('/v1/diaries/{diaryId}')
  Future<DiaryResponse> getDiary(@Path("diaryId") String diaryId);

  @POST('/v1/diaries')
  Future<DiaryResponse> createDiary(@Body() DiaryRequest request);

  @PATCH('/v1/diaries/{diaryId}')
  Future<DiaryResponse> updateDiary(
      @Path('diaryId') String diaryId, @Body() DiaryUpdateRequest request);

  @POST('/v1/diaries/{diaryId}/comments')
  Future<DiaryCommentResponse> createDiaryComments(@Path('diaryId') String diaryId, @Body() DiaryCommentRequest request);

  @GET('/v1/diaries/{diaryId}/comments')
  Future<List<DiaryCommentResponse>> getDiaryComments(@Path('diaryId') String diaryId);

  @DELETE('/v1/diaries/{diaryId}/comments/{commentId}')
  Future<APIResponse> deleteComment(@Path('diaryId') String diaryId, @Path('commentId') String commentId);

  @POST('/v1/diaries/{diaryId}/like')
  Future<FeedResponse> likeDiary(@Path('diaryId') String diaryId);

  @POST('/v1/diaries/{diaryId}/unlike')
  Future<FeedResponse> unlikeDiary(@Path('diaryId') String diaryId);

  @GET('/v1/users/{friendId}/diaries')
  Future<DiaryResponse> getFriendDiaryByDate(
      @Path("friendId") String friendId, @Query("date") String date);

  @GET('/v1/users/{friendId}/diaries/statistics')
  Future<Map<String, String>> getFriendMonthlyStatistics(
      @Path("friendId") String friendId,
      @Query("year") int year,
      @Query("month") int month);

  @GET('/v1/users/{friendId}/diaries/statistics')
  Future<Map<String, String>> getFriendYearlyStatistics(
      @Path("friendId") String friendId, @Query("year") int year);

  @GET('/v1/feeds')
  Future<List<FeedResponse>> getFeeds(@Query("size") int size);

  @GET('/v1/feeds')
  Future<List<FeedResponse>> getFeedsWithId(
      @Query("size") int size, @Query("baseId") String baseId);

  @GET('/v1/feeds')
  Future<List<FeedResponse>> getFriendFeed(
      @Query("size") int size, @Query("userId") String userId);

  @GET('/v1/feeds')
  Future<List<FeedResponse>> getFriendFeedWithId(@Query("size") int size,
      @Query("userId") String userId, @Query("baseId") String baseId);
}
