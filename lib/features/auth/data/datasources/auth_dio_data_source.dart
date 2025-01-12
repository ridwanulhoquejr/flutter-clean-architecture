// import 'package:clean_architecture_with_bloc/features/auth/data/models/user_model.dart';
// import 'package:dio/dio.dart';
// import 'package:retrofit/http.dart';

// part 'auth_dio_data_source.g.dart';

// @RestApi()
// abstract class RetroFitClient {
//   factory RetroFitClient(
//     Dio dio, {
//     String baseUrl,
//   }) = _RetroFitClient;

//   @GET('/login')
//   Future<UserModel> login(@Body() Map<String, dynamic> loginModel);
// }

// //! comment this class as we don't need the implementation
// // class AuthDioDataSource implements RetroFitClient {
// //   final RetroFitClient retroFitClient;

// //   AuthDioDataSource(this.retroFitClient);

// //   Future<UserModel> login({
// //     required String email,
// //     required String password,
// //   }) async {
// //     try {
// //       return await retroFitClient.login({
// //         'email': email,
// //         'password': password,
// //       });
// //     } on Exception {
// //       rethrow;
// //     }
// //   }

// //   @override
// //   // TODO: implement currentUserSession
// //   Session? get currentUserSession => throw UnimplementedError();

// //   @override
// //   Future<UserModel?> getCurrentUserData() {
// //     // TODO: implement getCurrentUserData
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<UserModel> loginWithEmailPassword(
// //       {required String email, required String password}) {
// //     // TODO: implement loginWithEmailPassword
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<UserModel> signUpWithEmailPassword(
// //       {required String name, required String email, required String password}) {
// //     // TODO: implement signUpWithEmailPassword
// //     throw UnimplementedError();
// //   }
// // }
