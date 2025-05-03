// TODO: add icon paths
enum BottomNavItem {
  home('Home', 'home-icon'),
  category('Category', 'category-icon'),
  cart('Cart', 'cart-icon'),
  wishlist('Wishlist', 'wishlist-icon'),
  profile('Profile', 'profile-icon');

  final String label;
  final String iconPath;
  const BottomNavItem(this.label, this.iconPath);

  static BottomNavItem fromIndex(int index) {
    return BottomNavItem.values[index % BottomNavItem.values.length];
  }

  static int toIndex(BottomNavItem item) {
    return BottomNavItem.values.indexOf(item);
  }
}
