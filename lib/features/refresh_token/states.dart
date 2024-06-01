abstract class RefreshTokenStates {}

class RefreshTokenInitialState extends RefreshTokenStates {}

class RefreshTokenLoadingState extends RefreshTokenStates {}

class RefreshTokenSuccessState extends RefreshTokenStates {}

class RefreshTokenFailedState extends RefreshTokenStates {}

class RefreshTokenErrorNetworkState extends RefreshTokenStates {}
