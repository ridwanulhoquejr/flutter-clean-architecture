import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// A custom platform-aware page that uses `CupertinoPage` for iOS
/// and `NoTransitionPage` for other platforms.
class AdaptivePage extends Page<dynamic> {
  final Widget child;

  const AdaptivePage({required this.child});

  @override
  Route<dynamic> createRoute(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      // Use CupertinoPageRoute for iOS native transition
      return CupertinoPageRoute(
        builder: (context) => child,
        settings: this,
      );
    } else {
      // Use NoTransitionPage for smooth, non-animated transitions on other platforms
      // MaterialPage having some bounce effect on page transition, I personally hate it!
      return NoTransitionPageRoute(
        child: child,
        settings: this,
      );
    }
  }
}

/// A custom `NoTransitionPageRoute` to use with `NoTransitionPage`.
class NoTransitionPageRoute extends PageRouteBuilder<dynamic> {
  final Widget child;

  NoTransitionPageRoute({required this.child, super.settings})
      : super(
          pageBuilder: (_, __, ___) => child,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}
