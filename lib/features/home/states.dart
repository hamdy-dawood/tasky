abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class PaginationHomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {}

class HomeNetworkErrorState extends HomeStates {}

class HomeFailedState extends HomeStates {
  final String msg;

  HomeFailedState({required this.msg});
}

class OnSelectedState extends HomeStates {}
