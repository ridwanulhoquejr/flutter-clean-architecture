part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // feature specific dependencies
  _initAuth();
  _initBlog();
  _initTodo();

  // core dependencies
  // like internet connection, Dio, shared pref, etc
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  // initialize Dio instance
  serviceLocator.registerLazySingleton(() => _dioService());
}

Dio _dioService() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );
  return dio;
}

void _initAuth() {
  // registerFactory: It creates a new instance of the object every time it is requested.
  // example of registerFactory will be our `Usecases`, `Repositories`, `Datasources`, etc.

  // registerLazySingleton: It creates a single instance of the object and provides this instance every time it is requested.
  // example of registerLazySingleton will be our `Dio`, `SharedPreferences`, `Bloc`, `Providers` etc.

  // Datasource
  // serviceLocator
  //   ..registerFactory<AuthRemoteDataSource>(
  //     // generics is for knowing that i have returned the Impl class but actual dependency is the interface class
  //     // otherwise, it will not work
  //     () => AuthRemoteDataSourceImpl(
  //       serviceLocator(),
  //     ),
  //   )
  // Repository
  // ..registerFactory<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     serviceLocator(),
  //     serviceLocator(),
  //   ),
  // )
  // Usecases
  // registerFactory(
  //   () => UserSignUp(
  //     serviceLocator(),
  //   ),
  // )
  // ..registerFactory(
  //   () => UserLogin(
  //     serviceLocator(),
  //   ),
  // )
  // ..registerFactory(
  //   () => CurrentUser(
  //     serviceLocator(),
  //   ),
  // )
  // // Bloc
  // ..registerLazySingleton(
  //   () => AuthBloc(
  //     userSignUp: serviceLocator(),
  //     userLogin: serviceLocator(),
  //     currentUser: serviceLocator(),
  //     appUserCubit: serviceLocator(),
  //   ),
  // );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}

void _initTodo() {
  // retrofit
  serviceLocator
    ..registerLazySingleton<TodoRetroFitClient>(
      () => TodoRetroFitClient(
        serviceLocator<Dio>(),
        baseUrl: 'https://jsonplaceholder.typicode.com',
      ),
    )

    // Datasource
    ..registerFactory<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(
        serviceLocator<TodoRetroFitClient>(),
      ),
    )
    // Repository
    ..registerFactory<TodoRepository>(
      () => TodoRepositoryImpl(
        serviceLocator<TodoRemoteDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => GetAllTodos(
        serviceLocator<TodoRepository>(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => TodoBloc(
        getTodo: serviceLocator<GetAllTodos>(),
      ),
    );
}
