import 'package:flutter/material.dart';
import 'package:orb_test_app/src/app/root_scope.dart';
import 'package:orb_ui_kit/orb_ui_kit.dart';

class OrbApp extends StatefulWidget {
  const OrbApp({super.key});

  @override
  State<OrbApp> createState() => _OrbAppState();
}

class _OrbAppState extends State<OrbApp> {
  final Key _builderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OrbTheme.light,
      darkTheme: OrbTheme.dark,
      home: const _PlaceholderHome(),
      builder: (context, child) => MediaQuery(
        key: _builderKey,
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: RootScope(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('orb_test_app')),
      body: Center(
        child: Text('orb_test_app', style: context.orbTextTheme.headlineMedium),
      ),
    );
  }
}
