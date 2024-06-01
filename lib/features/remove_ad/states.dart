abstract class RemoveAdStates {}

class RemoveAdInitialState extends RemoveAdStates {}

class RemoveAdLoadingState extends RemoveAdStates {}

class RemoveAdSuccessState extends RemoveAdStates {}

class RemoveAdNetworkErrorState extends RemoveAdStates {}

class RemoveAdFailedState extends RemoveAdStates {
  final String msg;

  RemoveAdFailedState({required this.msg});
}
