import 'package:clean_architecture_with_bloc/core/network/connection_checker.dart';
import 'package:clean_architecture_with_bloc/core/network/dio_client.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/datasources/todo_retrofit_client.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/usecases/get_todo_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'init_dependencies.main.dart';
