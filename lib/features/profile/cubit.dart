import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/features/refresh_token/view.dart';

import 'model.dart';
import 'states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  String token = CacheHelper.get(key: "access_token") ?? "";
  final dioManager = DioManager();
  final logger = Logger();

  UserInfoModel? user;

  Future<void> getUserInfo() async {
    emit(ProfileLoadingState());

    try {
      final response = await dioManager.get(
        UrlsStrings.profileUrl,
      );

      if (response.statusCode == 200) {
        user = UserInfoModel.fromJson(response.data);
        emit(ProfileSuccessState());
      } else {
        emit(ProfileFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(ProfileFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(ProfileFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(ProfileNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else {
        emit(ProfileFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(ProfileNetworkErrorState());
    }
    logger.e(e);
  }
}
