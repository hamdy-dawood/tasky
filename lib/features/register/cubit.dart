import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/cache_helper.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';

import 'controller.dart';
import 'states.dart';

class UserRegisterCubit extends Cubit<UserRegisterStates> {
  UserRegisterCubit() : super(UserRegisterInitialState());

  final dioManager = DioManager();
  final formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();
  final logger = Logger();
  String phoneNumber = "";
  String number = "";
  bool isObscure = true;

  Future<void> userRegister() async {
    if (formKey.currentState!.validate() && number.isNotEmpty) {
      emit(UserRegisterLoadingState());
      try {
        final response = await dioManager.post2(
          UrlsStrings.registerUrl,
          data: json.encode({
            "displayName": controllers.nameController.text,
            "experienceYears": controllers.experienceController.text,
            "phone": phoneNumber,
            "address": controllers.addressController.text,
            "level": experienceLevel,
            "password": controllers.passwordController.text,
          }),
        );
        if (response.statusCode == 201) {
          emit(UserRegisterSuccessState());
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
          emit(UserRegisterFailedState(msg: response.data["message"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(UserRegisterFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(UserRegisterFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(UserNetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(UserRegisterFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(UserNetworkErrorState());
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

  String experienceLevel = "";
  List<String> experienceLevelName = [
    "fresh",
    "junior",
    "midLevel",
    "senior",
  ];

  void updateExperienceLevel({required String level}) {
    experienceLevel = level;
    emit(ChangeExperienceLevelState());
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
