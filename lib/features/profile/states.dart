abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class ProfileNetworkErrorState extends ProfileStates {}

class ProfileFailedState extends ProfileStates {
  final String msg;

  ProfileFailedState({required this.msg});
}
