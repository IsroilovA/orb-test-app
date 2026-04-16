import 'package:flutter/material.dart';

const double _loadingIndicatorSize = 20;
const double _loadingIndicatorStrokeWidth = 2;

class OrbButtonLoadingIndicator extends StatelessWidget {
  const OrbButtonLoadingIndicator({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _loadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: _loadingIndicatorStrokeWidth,
        valueColor: color == null ? null : AlwaysStoppedAnimation<Color>(color!),
      ),
    );
  }
}
