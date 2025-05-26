import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutlineButtonComponent extends StatelessWidget {
  final Function? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final double? radius;

  const OutlineButtonComponent({
    super.key,
    this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width ?? Get.width, height: height ?? 50),
      child: OutlinedButton(
        onPressed: onPressed as void Function()?,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
