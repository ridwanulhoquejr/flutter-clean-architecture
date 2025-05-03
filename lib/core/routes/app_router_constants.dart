enum AppRouterConstants {
  splash('splash', '/'),

  //! ShellRoute
  home('home', '/home'),
  cart('cart', '/cart'),
  category('category', '/category'),
  profile('profile', '/profile'),
  wishlist('wishlist', '/wishlist'),

  //! GoRoute
  login('login', '/login'),
  signup('signup', '/signup');

  final String name;
  final String path;

  const AppRouterConstants(this.name, this.path);

  static List<String> get bottomNavRoutes => [
        home.path,
        cart.path,
        category.path,
        profile.path,
        wishlist.path,
      ];
}
