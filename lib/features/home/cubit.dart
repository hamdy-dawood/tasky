import 'package:dio/dio.dart';
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

  List<TasksModel> products = [];

  Future<void> getProducts() async {
    emit(HomeLoadingState());

    try {
      final response = await dioManager.get(
        UrlsStrings.tasks,
        json: {
          "page": "1",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        products = data.map((item) => TasksModel.fromJson(item)).toList();

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
}
