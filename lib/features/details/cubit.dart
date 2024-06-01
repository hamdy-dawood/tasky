import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/features/home/model.dart';
import 'package:tasky_app/features/refresh_token/view.dart';

import 'states.dart';

class DetailsCubit extends Cubit<DetailsStates> {
  DetailsCubit() : super(DetailsInitialState());

  static DetailsCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();

  TasksModel? task;

  Future<void> getTask({required String id}) async {
    emit(DetailsLoadingState());

    try {
      final response = await dioManager.get("${UrlsStrings.tasks}/$id");

      if (response.statusCode == 200) {
        task = TasksModel.fromJson(response.data);
        emit(DetailsSuccessState());
      } else {
        emit(DetailsFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(DetailsFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(DetailsFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(DetailsNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else {
        emit(DetailsFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(DetailsNetworkErrorState());
    }
    logger.e(e);
  }
}

class MenuItem {
  final String text;
  final Color color;

  MenuItem({
    required this.text,
    required this.color,
  });
}

class MenuItems {
  static MenuItem itemEdit = MenuItem(
    text: "Edit",
    color: ColorManager.black3,
  );
  static MenuItem itemDelete = MenuItem(
    text: "Delete",
    color: ColorManager.redPrimary,
  );

  static List<MenuItem> items = [
    itemEdit,
    itemDelete,
  ];
}
