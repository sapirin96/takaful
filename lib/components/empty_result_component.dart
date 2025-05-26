import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../configs/color_config.dart';

class EmptyResultComponent extends StatelessWidget {
  final Function? onPressed;
  final double? height;

  const EmptyResultComponent({super.key, this.onPressed, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height:
          height ?? Get.height - Get.statusBarHeight - Get.bottomBarHeight - 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'lib/assets/animations/empty-animation.json',
            width: 160,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 0),
          Text('No Results'.tr),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MaterialButton(
              onPressed: onPressed as void Function()?,
              color: ColorConfig.blue,
              child: Text(
                'Retry'.tr,
                style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
