import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tasky_app/core/networking/dio_helper.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';

import 'states.dart';

class RemoveAdCubit extends Cubit<RemoveAdStates> {
  RemoveAdCubit() : super(RemoveAdInitialState());

  static RemoveAdCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();

  Future<void> removeAd({required String itemId}) async {
    emit(RemoveAdLoadingState());

    try {
      final response = await dioManager.delete(
        "${UrlsStrings.tasks}/$itemId",
      );

      if (response.statusCode == 200) {
        emit(RemoveAdSuccessState());
      } else {
        emit(RemoveAdFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(RemoveAdFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      emit(RemoveAdFailedState(msg: "Request was cancelled"));
    } else if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      emit(RemoveAdNetworkErrorState());
    } else if (e.type == DioExceptionType.badResponse) {
      emit(RemoveAdFailedState(msg: e.response!.data["message"]));
    } else {
      emit(RemoveAdNetworkErrorState());
    }
    logger.e(e);
  }
}
