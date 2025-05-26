import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/home/views/home_account_view.dart';
import 'package:takaful/app/modules/home/views/home_carousel_view.dart';
import 'package:takaful/app/modules/home/views/home_menu_view.dart';
import 'package:takaful/app/modules/home/views/home_partners_view.dart';
import 'package:takaful/app/modules/member/views/create_member_view.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../../configs/color_config.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import 'sidebar_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Takaful Cambodia'.tr),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.NOTIFICATION);
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: Get.height,
            minWidth: Get.width,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              Stack(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 130,
                    ),
                    width: Get.width,
                    child: const HomeAccountView(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: const HomeMenuView(),
                  ),
                ],
              ),
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
                child: const HomeCarouselView(),
              ),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 150,
                ),
                margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
                child: const HomePartnersView(),
              ),
              Obx(() {
                String? roleName = Get.find<AuthService>().user.value?.roleName;

                return ConditionalBuilder(
                  condition: roleName?.toLowerCase() == "administrator" ||
                      roleName?.toLowerCase() == "staff",
                  builder: (_) => Container(
                    margin: const EdgeInsets.only(top: 20, left: 12, right: 12),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const CreateMemberView());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ColorConfig.gold,
                        minimumSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text('Enroll'.tr),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      drawer: const SidebarView(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
