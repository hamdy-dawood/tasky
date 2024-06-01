import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';

import 'controller.dart';
import 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  final dioManager = DioManager();
  final logger = Logger();
  final controllers = LoginControllers();
  bool isObscure = true;
  String phoneNumber = "";
  String number = "";

  Future<void> login() async {
    emit(LoginLoadingState());
    try {
      final response = await dioManager.post2(
        UrlsStrings.loginUrl,
        data: json.encode({
          "phone": phoneNumber,
          "password": controllers.passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        emit(LoginSuccessState());
        CacheHelper.put(
          key: 'id',
          value: "${response.data['_id']}",
        );
        CacheHelper.put(
          key: 'access_token',
          value: "${response.data['access_token']}",
        );
        CacheHelper.put(
          key: 'refresh_token',
          value: "${response.data['refresh_token']}",
        );
        logger.i(response.data["access_token"]);
      } else {
        emit(LoginFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(LoginFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(LoginFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 421) {
          emit(LoginBlockedState());
        } else {
          emit(LoginFailedState(msg: e.response?.data["message"]));
        }
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }

  onInputChanged(PhoneNumber phone) {
    phoneNumber = "${phone.countryCode}${phone.number}";
    number = phone.number;
    emit(ChangeNumberState());
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
