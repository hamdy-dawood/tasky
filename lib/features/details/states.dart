abstract class DetailsStates {}

class DetailsInitialState extends DetailsStates {}

class DetailsLoadingState extends DetailsStates {}

class DetailsSuccessState extends DetailsStates {}

class DetailsNetworkErrorState extends DetailsStates {}

class DetailsFailedState extends DetailsStates {
  final String msg;

  DetailsFailedState({required this.msg});
}
