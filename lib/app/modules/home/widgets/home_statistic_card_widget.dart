import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/configs/color_config.dart';

class HomeStatisticCardWidget extends StatefulWidget {
  final String title;
  final String value;
  final Function onPressed;

  const HomeStatisticCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });

  @override
  State<HomeStatisticCardWidget> createState() =>
      _HomeStatisticCardWidgetState();
}

class _HomeStatisticCardWidgetState extends State<HomeStatisticCardWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minHeight: 55,
        ),
        decoration: BoxDecoration(
          color: ColorConfig.blue,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed as Function(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  widget.value,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                Text(
                  widget.title,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
