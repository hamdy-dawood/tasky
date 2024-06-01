abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class NetworkErrorState extends LoginStates {}

class LoginBlockedState extends LoginStates {}

class LoginFailedState extends LoginStates {
  final String msg;

  LoginFailedState({required this.msg});
}

class FillEmailState extends LoginStates {}

class FillLockState extends LoginStates {}

class ChanceVisibilityState extends LoginStates {}

class ChanceRememberState extends LoginStates {}

class ChangeNumberState extends LoginStates {}

class LoginTimeBlockedState extends LoginStates {
  final String msg;
  final int time;

  LoginTimeBlockedState({required this.msg, required this.time});
}

//================================================================

class LoginWithGoogleLoadingState extends LoginStates {}

class LoginWithGoogleSuccessState extends LoginStates {}

class LoginWithGoogleErrorState extends LoginStates {
  final String msg;

  LoginWithGoogleErrorState({required this.msg});
}

//================================================================

class LoginWithAppleLoadingState extends LoginStates {}

class LoginWithAppleSuccessState extends LoginStates {}

class LoginWithAppleErrorState extends LoginStates {
  final String msg;

  LoginWithAppleErrorState({required this.msg});
}
