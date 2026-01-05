import 'package:appcrew_notes_app/core/session/session_manager.dart';
import 'package:appcrew_notes_app/data/data%20sources/auth_firebase_datasource.dart';
import 'package:appcrew_notes_app/presentation/bloc/auth/auth_event.dart';
import 'package:appcrew_notes_app/presentation/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFirebaseDatasource datasource;

  AuthBloc(this.datasource) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<LogoutEvent>(_logout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
  final remember = await SessionManager.isRememberMe();
  final user = datasource.currentUser;

  if (remember && user != null) {
    emit(AuthAuthenticated(user));
  } else {
    emit(const AuthUnauthenticated());
  }
}
Future<void> _login(LoginEvent e, Emitter<AuthState> emit) async {
  emit(const AuthLoading());
  try {
    final user = await datasource.login(e.email, e.password);

    // Save remember me
    if (e.rememberMe) {
      await SessionManager.setRememberMe(true);
    } else {
      await SessionManager.setRememberMe(false);
    }

    emit(AuthAuthenticated(user));
  } catch (error) {
    emit(AuthError(error.toString()));
  }
}


  Future<void> _register(RegisterEvent e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await datasource.register(e.email, e.password);
      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

 Future<void> _logout(LogoutEvent e, Emitter<AuthState> emit) async {
  emit(const AuthLoading());
  await datasource.logout();
  await SessionManager.clear();
  emit(const AuthUnauthenticated());
}

}
