import 'package:clean_architecture_with_bloc/core/routes/adaptive_page.dart';
import 'package:clean_architecture_with_bloc/core/routes/app_router_constants.dart';
import 'package:clean_architecture_with_bloc/features/auth/presentation/pages/login.dart';
import 'package:clean_architecture_with_bloc/features/main/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:clean_architecture_with_bloc/features/main/presentation/misc/bottom_navigation_misc.dart';
import 'package:clean_architecture_with_bloc/features/main/presentation/pages/main_page_.dart';
import 'package:clean_architecture_with_bloc/features/todo/presentation/pages/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static String get currentPath {
    final RouteMatch lastMatch =
        goRouter.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : goRouter.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  static final goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRouterConstants.splash.path,
    routes: [
      GoRoute(
        path: AppRouterConstants.login.path,
        pageBuilder: (context, state) => const AdaptivePage(
          child: LoginPage(),
        ),
      ),

      /// Shell route for the main pages
      /// This route will be used to wrap the main pages with the main page
      /// to have a bottom navigation bar
      /// This route will also handle the bottom navigation bar
      /// and change the bottom navigation item based on the route
      ///
      ShellRoute(
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: MainPage(child: child),
          );
        },
        routes: [
          GoRoute(
            path: AppRouterConstants.home.path,
            name: AppRouterConstants.home.name,
            pageBuilder: (context, state) {
              // Change the bottom navigation item to home when redirected
              BlocProvider.of<BottomNavigationCubit>(context)
                  .changeItem(BottomNavItem.home);

              return const NoTransitionPage(
                child: TodoPage(),
              );
            },
          ),
        ],
      ),
    ],
  );

  static void bottomNavIndexOnTap(int index) {
    if (index == 0) {
      goHome();
    } else if (index == 1) {
      goCategory();
    } else if (index == 2) {
      goCart();
    } else if (index == 3) {
      goWishlist();
    } else if (index == 4) {
      goProfile();
    }
  }

  static void goBack() {
    if (goRouter.canPop()) {
      goRouter.pop();
    } else {
      navigatorKey.currentState!.pop();
    }
  }

  //! 5 main routes (in the bottom navigation bar)
  static void goHome() => goRouter.go(AppRouterConstants.home.path);
  static void goCategory() => goRouter.go(AppRouterConstants.category.path);
  static void goCart() => goRouter.go(AppRouterConstants.cart.path);
  static void goWishlist() => goRouter.go(AppRouterConstants.wishlist.path);
  static void goProfile() => goRouter.go(AppRouterConstants.profile.path);

  //! static method to navigate to a specific route
  static void goSplash() => goRouter.go(AppRouterConstants.splash.path);
  static void goLogin() => goRouter.push(AppRouterConstants.login.path);
  static void goSignup() => goRouter.push(AppRouterConstants.signup.path);

  static void pushNamedAndRemoveUntil(String name) {
    while (goRouter.canPop()) {
      goRouter.pop();
    }
    goRouter.replaceNamed(name);
  }
}
