import 'package:appcrew_notes_app/data/data%20sources/auth_firebase_datasource.dart';
import 'package:appcrew_notes_app/presentation/auth_gate.dart';
import 'package:appcrew_notes_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:appcrew_notes_app/presentation/bloc/auth/auth_event.dart';
 import 'package:appcrew_notes_app/presentation/screens/login/login_screen.dart';
import 'package:appcrew_notes_app/presentation/screens/notes/notes_screen.dart';
import 'package:appcrew_notes_app/presentation/screens/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(AuthFirebaseDatasource())..add(const AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        // initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/notes': (_) => const NotesScreen(userId: ''),
        },
        home: AuthGate(),
      ),
    );
  }
}
