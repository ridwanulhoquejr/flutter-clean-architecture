import 'package:clean_architecture_with_bloc/core/routes/app_router.dart';
import 'package:clean_architecture_with_bloc/features/main/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:clean_architecture_with_bloc/features/main/presentation/misc/bottom_navigation_misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, -2),
                blurRadius: 3,
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: BottomNavItem.toIndex(state.selectedItem),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              BlocProvider.of<BottomNavigationCubit>(context)
                  .changeItemByIndex(index);
              AppRouter.bottomNavIndexOnTap(index);
            },
            items: BottomNavItem.values.map(
              (item) {
                // TODO: add icons to the items
                return BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 20,
                  ),
                  label: item.label,
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
