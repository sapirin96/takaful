import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/color_config.dart';

class PrimaryButtonComponent extends StatelessWidget {
  final Function? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final double radius;
  final Color? color;

  const PrimaryButtonComponent({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.radius = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: width ?? Get.width, height: height ?? 50),
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return (color ?? ColorConfig.blue).withOpacity(0.8);
              } else if (states.contains(WidgetState.disabled)) {
                return ColorConfig.grey;
              }
              return (color ?? ColorConfig.blue);
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
