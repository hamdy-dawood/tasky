import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';

import 'states.dart';

class RefreshTokenCubit extends Cubit<RefreshTokenStates> {
  RefreshTokenCubit() : super(RefreshTokenInitialState());

  static RefreshTokenCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();

  Future<void> getToken() async {
    emit(RefreshTokenLoadingState());

    try {
      final response = await dioManager.get(
        UrlsStrings.refreshToken,
        json: {
          "token": "${CacheHelper.get(key: "refresh_token") ?? ""}",
        },
      );

      if (response.statusCode == 200) {
        emit(RefreshTokenSuccessState());
        CacheHelper.put(
          key: 'access_token',
          value: "${response.data['access_token']}",
        );
        logger.i(response.data['access_token']);
      } else {
        emit(RefreshTokenFailedState());
      }
    } on DioException catch (e) {
      handleDioException(e);
      logger.e(e);
    } catch (e) {
      emit(RefreshTokenFailedState());
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(RefreshTokenFailedState());
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(RefreshTokenErrorNetworkState());
    } else if (e.type == DioExceptionType.badResponse) {
      emit(RefreshTokenFailedState());
    } else {
      emit(RefreshTokenErrorNetworkState());
    }
    logger.e(e);
  }
}
