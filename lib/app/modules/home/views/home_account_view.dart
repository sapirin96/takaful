import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/auth/views/auth_register_view.dart';
import 'package:takaful/app/services/auth_service.dart';
import 'package:takaful/components/cached_network_image_component.dart';
import 'package:takaful/configs/color_config.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeAccountView extends StatefulWidget {
  const HomeAccountView({super.key});

  @override
  State<HomeAccountView> createState() => _HomeAccountViewState();
}

class _HomeAccountViewState extends State<HomeAccountView>
    with AutomaticKeepAliveClientMixin<HomeAccountView> {
  final AuthService auth = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Obx(
        () => ConditionalBuilder(
          condition: auth.authenticated.value == true,
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorConfig.gold,
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(
                          color: ColorConfig.gold,
                          width: 2,
                        ),
                      ),
                      child: CachedNetworkImageComponent(
                        imageUrl: auth.user.value?.imageUrl,
                        width: 70,
                        height: 70,
                        circular: 70,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            'Hi @name'.trParams({
                              "name": "${auth.user.value?.name}",
                            }),
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorConfig.gold,
                            ),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: ColorConfig.gold,
                              size: 14,
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.SETTING);
                            },
                            label: Text(
                              'View Profile'.tr,
                              style: TextStyle(
                                color: ColorConfig.gold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          fallback: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorConfig.gold,
                ),
              ),
              Text(
                'Please login or create an account to continue'.tr,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: ColorConfig.gold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.lazyPut<AuthController>(() => AuthController());
                      Get.to(() => const AuthRegisterView());
                    },
                    icon: const Icon(
                      Icons.app_registration,
                      color: Colors.blueGrey,
                    ),
                    label: Text(
                      'Register'.tr,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.AUTH);
                    },
                    icon: Icon(
                      Icons.login,
                      color: ColorConfig.blue,
                    ),
                    label: Text(
                      'Login'.tr,
                      style: TextStyle(
                        color: ColorConfig.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
