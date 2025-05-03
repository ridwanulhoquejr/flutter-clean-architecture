part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  final BottomNavItem selectedItem;

  const BottomNavigationState(this.selectedItem);

  @override
  List<Object> get props => [selectedItem];

  @override
  bool get stringify => true;
}
