import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/features/refresh_token/view.dart';

import 'model.dart';
import 'states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isMainLoad = true;

  List<TasksModel> products = [];

  Future<void> getProducts({required String status}) async {
    isMainLoad ? emit(HomeLoadingState()) : emit(PaginationHomeLoadingState());

    try {
      final response = await dioManager.get(
        UrlsStrings.tasks,
        json: {
          "page": currentPage,
          if (status.isNotEmpty) "status": status,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        isMainLoad == true
            ? products = data.map((item) => TasksModel.fromJson(item)).toList()
            : products
                .addAll(data.map((item) => TasksModel.fromJson(item)).toList());

        emit(HomeSuccessState());
      } else {
        emit(HomeFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(HomeFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(HomeFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(HomeNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response?.statusCode == 401) {
        MagicRouter.navigateTo(page: const RefreshTokenView());
      } else {
        emit(HomeFailedState(msg: e.response?.data["message"]));
      }
    } else {
      emit(HomeNetworkErrorState());
    }
    logger.e(e);
  }

  //================================================================

  double get pages {
    if (products.length + 1 <= 0) return 0.0;
    return (products.length + 1) / 20;
  }

  int get roundedNumber {
    return pages.ceil();
  }

  Future<void> getNextPage({
    required String status,
  }) async {
    if (currentPage < roundedNumber) {
      isMainLoad = false;
      currentPage++;
      await getProducts(
        status: status,
      );
    }
  }

  void onRefresh({
    required String status,
  }) {
    products.clear();
    currentPage = 1;
    isMainLoad = true;
    getProducts(
      status: status,
    );
  }

  //================================================================
  int selectedItem = 0;
  String selectedItemName = "";

  onSelectedItem({
    required int index,
    required String name,
  }) {
    selectedItem = index;
    selectedItemName = name;
    emit(OnSelectedState());
  }
}
