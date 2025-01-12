// import 'package:clean_architecture_with_bloc/core/constants/constants.dart';
// import 'package:clean_architecture_with_bloc/core/error/exceptions.dart';
// import 'package:clean_architecture_with_bloc/core/error/failures.dart';
// import 'package:clean_architecture_with_bloc/core/network/connection_checker.dart';
// import 'package:clean_architecture_with_bloc/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:clean_architecture_with_bloc/core/common/entities/user.dart';
// import 'package:clean_architecture_with_bloc/features/auth/data/models/user_model.dart';
// import 'package:clean_architecture_with_bloc/features/auth/domain/repository/auth_repository.dart';
// import 'package:fpdart/fpdart.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final ConnectionChecker connectionChecker;

//   const AuthRepositoryImpl(
//     this.remoteDataSource,
//     this.connectionChecker,
//   );

//   @override
//   Future<Either<Failure, User>> currentUser() async {
//     try {
//       if (!await (connectionChecker.isConnected)) {
//         final session = remoteDataSource.currentUserSession;

//         if (session == null) {
//           return left(const Failure('User not logged in!'));
//         }

//         return right(
//           UserModel(
//             id: session.user.id,
//             email: session.user.email ?? '',
//             name: '',
//           ),
//         );
//       }
//       final user = await remoteDataSource.getCurrentUserData();
//       if (user == null) {
//         return left(
//           const Failure('User not logged in!'),
//         );
//       }

//       return right(user);
//     } on ServerException catch (e) {
//       return left(
//         Failure(e.message),
//       );
//     }
//   }

//   @override
//   Future<Either<Failure, User>> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     return _getUser(
//       () async => await remoteDataSource.loginWithEmailPassword(
//         email: email,
//         password: password,
//       ),
//     );
//   }

//   @override
//   Future<Either<Failure, User>> signUpWithEmailPassword({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     return _getUser(
//       () async => await remoteDataSource.signUpWithEmailPassword(
//         name: name,
//         email: email,
//         password: password,
//       ),
//     );
//   }

//   Future<Either<Failure, User>> _getUser(
//     Future<User> Function() fn,
//   ) async {
//     // * Note: this try/catch block is important to catch the ServerException from the `remoteDataSource`
//     try {
//       if (!await (connectionChecker.isConnected)) {
//         return left(
//           const Failure(Constants.noConnectionErrorMessage),
//         );
//       }
//       final user = await fn();

//       return right(user);
//     } on ServerException catch (e) {
//       return left(
//         Failure(e.message),
//       );
//     }
//   }
// }
