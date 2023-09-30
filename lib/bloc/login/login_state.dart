part of 'login_bloc.dart';

class LoginState {
  final bool susActive;

  LoginState({
    this.susActive = false,
  });

  LoginState copyWith({
    bool? susActive,
  }) =>
      LoginState(
        susActive: susActive ?? this.susActive,
      );
}
