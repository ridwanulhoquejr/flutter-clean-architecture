import 'package:clean_architecture_with_bloc/core/theme/theme.dart';
import 'package:clean_architecture_with_bloc/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:clean_architecture_with_bloc/features/todo/presentation/pages/todo_page.dart';
import 'package:clean_architecture_with_bloc/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (_) => serviceLocator<AppUserCubit>(),
        // create: (_) => AuthBloc(
        //   userSignUp: UserSignUp(
        //     AuthRepositoryImpl(AuthRemoteDataSourceImpl(supebaseClient),
        //         ConnectionCheckerImpl()),
        //     userLogin: null,
        //     currentUser: null,
        //     appUserCubit: null,
        //   ),
        // ),
        // ),
        BlocProvider(
          create: (_) => serviceLocator<TodoBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const TodoPage(),
    );
  }
}
