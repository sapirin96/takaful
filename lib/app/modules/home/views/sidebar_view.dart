import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/routes/app_pages.dart';
import 'package:takaful/configs/color_config.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../services/auth_service.dart';
import 'about_view.dart';
import 'contact_view.dart';
import 'privacy_view.dart';
import 'term_view.dart';

class SidebarView extends StatefulWidget {
  const SidebarView({super.key});

  @override
  State<SidebarView> createState() => _SidebarViewState();
}

class _SidebarViewState extends State<SidebarView> {
  final AuthService auth = Get.find<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Obx(
            () => UserAccountsDrawerHeader(
              accountName: Text(
                '${auth.user.value?.name ?? '__'} (${auth.user.value?.roleName ?? '__'})',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                auth.user.value?.email ?? '__',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: InkWell(
                onTap: () {
                  Get.toNamed(Routes.ACCOUNT);
                },
                child: CircleAvatar(
                  child: ConditionalBuilder(
                    condition: auth.authenticated.value == true,
                    builder: (_) => CachedNetworkImageComponent(
                      imageUrl: auth.user.value?.imageUrl,
                      placeholderImage: 'lib/assets/images/user.png',
                    ),
                    fallback: (_) => const Icon(Icons.person),
                  ),
                ),
              ),
              otherAccountsPictures: [
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await auth.signOut();
                  },
                ),
              ],
              decoration: BoxDecoration(
                color: ColorConfig.blue,
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.info),
            title: Text('About Us'.tr),
            onTap: () {
              Get.to(() => const AboutView());
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.contact_support),
            title: Text('Contact Us'.tr),
            onTap: () {
              Get.to(() => const ContactView());
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.file_copy_sharp),
            title: Text('Terms and Conditions'.tr),
            onTap: () {
              Get.to(() => const TermView());
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'.tr),
            onTap: () {
              Get.to(() => const PrivacyView());
            },
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.settings),
            title: Text('Settings'.tr),
            onTap: () {
              Get.toNamed(Routes.SETTING);
            },
          ),
          Obx(
            () => ConditionalBuilder(
              condition: auth.user.value?.roleName == 'administrator',
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.person),
                    title: Text('Users'.tr),
                    onTap: () {
                      Get.toNamed(Routes.USER);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.supervisor_account),
                    title: Text('Staffs'.tr),
                    onTap: () {
                      Get.toNamed(Routes.STAFF);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
