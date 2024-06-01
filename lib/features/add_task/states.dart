abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {}

class AddTaskNetworkErrorState extends AddTaskStates {}

class AddTaskFailedState extends AddTaskStates {
  final String msg;

  AddTaskFailedState({required this.msg});
}

//================================================================

class UploadProductImageStates extends AddTaskStates {}

//================================================================

class AddImageLoadingState extends AddTaskStates {}

class AddImageSuccessState extends AddTaskStates {}

class AddImageNetworkErrorState extends AddTaskStates {}

class AddImageFailedState extends AddTaskStates {
  final String msg;

  AddImageFailedState({required this.msg});
}

//================================================================

class ChangePriorityState extends AddTaskStates {}

class UpdateDateStates extends AddTaskStates {}

//================================================================

class EditTaskInitialState extends AddTaskStates {}

class EditTaskLoadingState extends AddTaskStates {}

class EditTaskSuccessState extends AddTaskStates {}

class EditTaskNetworkErrorState extends AddTaskStates {}

class EditTaskFailedState extends AddTaskStates {
  final String msg;

  EditTaskFailedState({required this.msg});
}
