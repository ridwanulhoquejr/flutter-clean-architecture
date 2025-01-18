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
  serviceLocator.registerLazySingleton(() => DioClient.instance);

  //* registerFactory: It creates a new instance of the object every time it is requested.
  // example of registerFactory will be our `Usecases`, `Repositories`, `Datasources` etc.

  //* registerLazySingleton: It creates a single instance of the object and provides this instance every time it is requested.
  // example of registerLazySingleton will be our `Dio`, `SharedPreferences`, `Bloc`, `Providers` etc.
}

void _initAuth() {}

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
      ),
    )

    // Datasource
    ..registerLazySingleton<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(
        serviceLocator<TodoRetroFitClient>(),
      ),
    )
    // Repository
    ..registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(
        serviceLocator<TodoRemoteDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    // Usecases
    ..registerLazySingleton(
      () => GetAllTodos(
        serviceLocator<TodoRepository>(),
      ),
    );
  // ..registerFactory(
  //   () => AuthBloc();

  // )
}
