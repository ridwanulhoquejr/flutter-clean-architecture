import 'package:clean_architecture_with_bloc/features/main/presentation/misc/bottom_navigation_misc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(const BottomNavigationState(BottomNavItem.home));

  void changeItem(BottomNavItem item) {
    emit(BottomNavigationState(item));
  }

  void changeItemByIndex(int index) {
    emit(BottomNavigationState(BottomNavItem.fromIndex(index)));
  }
}
