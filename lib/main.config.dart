// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'core/repository/diary_repository.dart' as _i4;
import 'core/service/auth_service.dart' as _i3;
import 'core/service/diary_service.dart' as _i5;
import 'core/service/online_service.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.AuthService>(() => _i3.AuthService());
    gh.singleton<_i4.DiaryRepository>(_i4.DiaryRepository());
    gh.factory<_i5.DiaryService>(() => _i5.DiaryService());
    gh.singleton<_i6.OnlineService>(_i6.OnlineService());
    return this;
  }
}
