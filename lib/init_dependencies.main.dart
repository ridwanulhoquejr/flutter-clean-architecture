part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // core dependencies
  // like internet connection, Dio, shared pref, etc

  serviceLocator.registerFactory(() => InternetConnection());

  // core
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

  // feature specific dependencies
  _initTodo();
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
}
