part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SetSuscriptionActive extends LoginEvent {
  final bool susActive;

  SetSuscriptionActive(this.susActive);
}
