import 'package:appcrew_notes_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:appcrew_notes_app/presentation/bloc/auth/auth_state.dart';
import 'package:appcrew_notes_app/presentation/screens/login/login_screen.dart';
import 'package:appcrew_notes_app/presentation/screens/notes/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return NotesScreen(userId: state.user.uid);
        }

        return const LoginScreen();
      },
    );
  }
}
