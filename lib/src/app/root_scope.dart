import 'package:flutter/material.dart';

class RootScope extends StatefulWidget {
  const RootScope({required this.child, super.key});

  final Widget child;

  @override
  State<RootScope> createState() => RootScopeState();

  static RootScopeState of(BuildContext context, {bool listen = false}) =>
      _InheritedRootScope.of(context, listen: listen).data;
}

class RootScopeState extends State<RootScope> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedRootScope(data: this, child: widget.child);
}

class _InheritedRootScope extends InheritedWidget {
  const _InheritedRootScope({required this.data, required super.child});

  final RootScopeState data;

  static _InheritedRootScope? maybeOf(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<_InheritedRootScope>()
      : context.getInheritedWidgetOfExactType<_InheritedRootScope>();

  static Never _notFoundInheritedWidgetOfExactType() =>
      throw ArgumentError('Out of scope, not found inherited widget a _InheritedRootScope of the exact type', 'out_of_scope');

  static _InheritedRootScope of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(_InheritedRootScope oldWidget) => false;
}
