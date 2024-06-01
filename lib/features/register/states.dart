abstract class UserRegisterStates {}

class UserRegisterInitialState extends UserRegisterStates {}

class UserRegisterLoadingState extends UserRegisterStates {}

class UserRegisterSuccessState extends UserRegisterStates {}

class ChangeNumberState extends UserRegisterStates {}

class ChanceVisibilityState extends UserRegisterStates {}

class ChangeExperienceLevelState extends UserRegisterStates {}

class UserRegisterFailedState extends UserRegisterStates {
  final String msg;

  UserRegisterFailedState({required this.msg});
}

class UserNetworkErrorState extends UserRegisterStates {}
