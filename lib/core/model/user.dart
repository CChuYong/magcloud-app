class User {
  final String nameTag;
  final String name;
  final bool isDiaryShared;
  final String profileImageUrl = "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg";
  User({required this.name, required this.nameTag, required this.isDiaryShared});
}
