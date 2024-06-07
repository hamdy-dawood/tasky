import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/features/refresh_token/view.dart';

import 'controller.dart';
import 'states.dart';

class AddTaskCubit extends Cubit<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();
  final formKey = GlobalKey<FormState>();
  final controllers = AddTaskControllers();
  File? productImage;
  DateTime? dateTime;
  String imageTextUploaded = "";

  Future<void> addImage() async {
    emit(AddImageLoadingState());

    if (productImage == null) {
      emit(AddImageFailedState(msg: "No image selected"));
      return;
    }

    try {
      final formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          productImage!.path,
          filename: productImage!.path.split("/").last,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      final response = await dioManager.post(
        UrlsStrings.addImageUrl,
        data: formData,
      );

      if (response.statusCode == 201) {
        emit(AddImageSuccessState());
        imageTextUploaded = "${response.data["image"]}";
      } else {
        emit(AddImageFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(AddImageFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioImageException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(AddImageFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(AddImageNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else {
        emit(AddImageFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(AddImageNetworkErrorState());
    }
    logger.e(e);
  }

  //================================================================

  Future<void> addTask() async {
    if (formKey.currentState!.validate()) {
      emit(AddTaskLoadingState());
      try {
        final response = await dioManager.post2(
          UrlsStrings.tasks,
          data: json.encode(
            {
              "image": imageTextUploaded,
              "title": controllers.titleController.text,
              "desc": controllers.descController.text,
              "priority": priority,
              "dueDate": "$dateTime",
            },
          ),
        );

        if (response.statusCode == 201) {
          emit(AddTaskSuccessState());
        } else {
          emit(AddTaskFailedState(msg: response.data["message"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(AddTaskFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(AddTaskFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(AddTaskNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else if (e.response?.statusCode == 413) {
        emit(AddTaskFailedState(msg: "Entity Too Large"));
      } else {
        emit(AddTaskFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(AddTaskNetworkErrorState());
    }
    logger.e(e);
  }

  //================================================================

  chooseProductImage() {
    ImagePicker.platform
        .getImage(source: ImageSource.gallery, imageQuality: 70)
        .then((value) {
      if (value != null) {
        productImage = File(value.path);
        emit(UploadProductImageStates());
      }
    });
  }

  void pressDate() async {
    dateTime = await showDatePicker(
      context: MagicRouter.currentContext,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 360)),
    );
    emit(UpdateDateStates());
  }

  //================================================================

  String priority = "";
  List<String> priorityName = [
    "low",
    "medium",
    "high",
  ];

  void updateExperienceLevel({required String priorityP}) {
    priority = priorityP;
    emit(ChangePriorityState());
  }

  //================================================================

  String status = "";
  List<String> statusName = [
    "inprogress",
    "waiting",
    "finished",
  ];

  void updateStatus({required String statusS}) {
    status = statusS;
    emit(ChangePriorityState());
  }

  //================================================================

  Future<void> editTask({required String id, required String user}) async {
    if (formKey.currentState!.validate()) {
      emit(EditTaskLoadingState());
      try {
        final response = await dioManager.put(
          "${UrlsStrings.tasks}/$id",
          data: json.encode(
            {
              "image": imageTextUploaded,
              "title": controllers.titleController.text,
              "desc": controllers.descController.text,
              "priority": priority,
              "status": status,
              "user": user,
            },
          ),
        );

        if (response.statusCode == 200) {
          emit(EditTaskSuccessState());
        } else {
          emit(EditTaskFailedState(msg: response.data["message"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(EditTaskFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioEditTaskException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(EditTaskFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(EditTaskNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else {
        emit(EditTaskFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(EditTaskNetworkErrorState());
    }
    logger.e(e);
  }

  //================================================================

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
