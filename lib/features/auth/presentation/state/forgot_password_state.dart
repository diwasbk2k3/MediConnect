import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? successMessage;
  final String? errorMessage;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? successMessage = _undefined,
    String? errorMessage = _undefined,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      successMessage:
          successMessage == _undefined ? this.successMessage : successMessage,
      errorMessage: errorMessage == _undefined ? this.errorMessage : errorMessage,
    );
  }

  static const _undefined = '__undefined__';

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
