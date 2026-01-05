// ignore_for_file: avoid_print

import 'package:appcrew_notes_app/core/session/session_manager.dart';
import 'package:appcrew_notes_app/presentation/screens/notes/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../register/register_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool rememberMe = true;

  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.indigo,  iconTheme: IconThemeData(color: Colors.white),),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthAuthenticated) {
              print("Login success! UserId: ${state.user.uid}");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => NotesScreen(userId: state.user.uid),
                ),
              );
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50,),
                  Text(
                    'Welcome Back 👋',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Login to continue taking notes'),
                  const SizedBox(height: 32),
              
                  TextField(
                    controller: emailCtrl,
                    focusNode: emailFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(passFocus),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  TextField(
                    controller: passCtrl,
                    focusNode: passFocus,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
              
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
  value: rememberMe,
  onChanged: (value) async {
    setState(() => rememberMe = value!);

    // Persist choice
    await SessionManager.setRememberMe(value!);
  },
),
                      const Text('Remember me'),
                    ],
                  ),
                  const SizedBox(height: 24),
              
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
         onPressed: isLoading
    ? null
    : () {
        final email = emailCtrl.text.trim();
        final password = passCtrl.text.trim();

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter email and password')));
          return;
        }

        context.read<AuthBloc>().add(
              LoginEvent(email, password, rememberMe),
            );
      },


                        
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Login',style: TextStyle(color: Colors.white),),
                        ),
                      );
                    },
                  ),
              
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Create an account'),
                    ),
                  ),
              
                  //const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
