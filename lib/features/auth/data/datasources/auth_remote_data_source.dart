import 'package:clean_architecture_with_bloc/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  // Future<UserModel?> getCurrentUserData();

  //
}

// implementation of the interface for retrofit
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final RetroFitClient retroFitClient;

//   AuthRemoteDataSourceImpl(
//     this.retroFitClient,
//   );

//   @override
//   Session? get currentUserSession => throw UnimplementedError();

//   @override
//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       return await retroFitClient.login(
//         {
//           'email': email,
//           'password': password,
//         },
//       );
//     } on Exception {
//       rethrow;
//     }
//   }

//   @override
//   Future<UserModel> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) =>
//       throw UnimplementedError();

//   @override
//   Future<UserModel?> getCurrentUserData() async {}
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final SupabaseClient supabaseClient;

//   AuthRemoteDataSourceImpl(
//     this.supabaseClient,
//   );

//   @override
//   Session? get currentUserSession => supabaseClient.auth.currentSession;

//   @override
//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signInWithPassword(
//         password: password,
//         email: email,
//       );
//       if (response.user == null) {
//         throw const ServerException('User is null!');
//       }
//       return UserModel.fromJson(response.user!.toJson());
//     } on AuthException catch (e) {
//       throw ServerException(e.message);
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }

//   @override
//   Future<UserModel> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signUp(
//         password: password,
//         email: email,
//         data: {
//           'name': name,
//         },
//       );
//       if (response.user == null) {
//         throw const ServerException('User is null!');
//       }
//       return UserModel.fromJson(response.user!.toJson());
//     } on AuthException catch (e) {
//       throw ServerException(e.message);
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }

//   @override
//   Future<UserModel?> getCurrentUserData() async {
//     try {
//       if (currentUserSession != null) {
//         final userData = await supabaseClient.from('profiles').select().eq(
//               'id',
//               currentUserSession!.user.id,
//             );
//         return UserModel.fromJson(userData.first).copyWith(
//           email: currentUserSession!.user.email,
//         );
//       }

//       return null;
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
// }
