import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
enum AuthStatus{initial, loading, authenticated, unauthenticated, registered, error, passwordChanged}

class AuthState extends Equatable{
  final AuthStatus status;
  final AuthEntity? authEntity;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? errorMessage = _undefined,
  }){
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage == _undefined ? this.errorMessage : errorMessage,
    );
  }

  static const _undefined = '__undefined__';
  
  @override
  List<Object?> get props => [status, authEntity, errorMessage]; 
}