import 'package:flutter/material.dart';

/// Exposes the selected tab index of LaoStockCustomBottomNav to any
/// descendant, so child pages (e.g. Watchlist) can switch tabs without
/// pushing a new nav route.
class NavScope extends InheritedNotifier<ValueNotifier<int>> {
  const NavScope({
    super.key,
    required ValueNotifier<int> index,
    required super.child,
  }) : super(notifier: index);

  /// Read the tab index notifier. Any widget below the scope can call
  /// `NavScope.of(context).value = 3;` to switch tabs.
  static ValueNotifier<int> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NavScope>();
    assert(scope != null, 'NavScope not found in widget tree');
    return scope!.notifier!;
  }
}
