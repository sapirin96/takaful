import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/providers/member_provider.dart';
import 'package:takaful/app/modules/member/views/create_member_view.dart';
import 'package:takaful/app/modules/member/views/view_member_view.dart';
import 'package:takaful/app/modules/membership/views/subscription_view.dart';
import 'package:takaful/packages/conditional_builder.dart';
import 'package:takaful/packages/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../configs/color_config.dart';
import '../../../data/models/member_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/setting_service.dart';
import '../../membership/views/membership_claim_view.dart';

class HomeMenuView extends StatefulWidget {
  const HomeMenuView({super.key});

  @override
  State<HomeMenuView> createState() => _HomeMenuViewState();
}

class _HomeMenuViewState extends State<HomeMenuView>
    with AutomaticKeepAliveClientMixin<HomeMenuView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      margin: const EdgeInsets.only(top: 6.0, left: 12, right: 12),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
          bottom: Radius.circular(30.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Obx(() {
        String? roleName = Get.find<AuthService>().user.value?.roleName;

        if (roleName?.toLowerCase() == "administrator" ||
            roleName?.toLowerCase() == "staff") {
          return Column(
            children: [
              SizedBox(
                height: Get.height * 0.11,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HomeMembersMenu(),
                    SizedBox(width: 12),
                    HomeSubscriptionMenu(),
                    SizedBox(width: 12),
                    HomeClaimMenu(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: Get.height * 0.11,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HomeAgenciesMenu(),
                    SizedBox(width: 12),
                    HomeDonationMenu(),
                    SizedBox(width: 12),
                    HomeZakatMenu(),
                  ],
                ),
              ),
            ],
          );
        }

        if (roleName?.toLowerCase() == "agency" ||
            roleName?.toLowerCase() == "super_agency") {
          return Column(
            children: [
              SizedBox(
                height: Get.height * 0.11,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HomeMembersMenu(),
                    SizedBox(width: 12),
                    HomeSubscriptionMenu(),
                    SizedBox(width: 12),
                    HomeClaimMenu(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: Get.height * 0.11,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HomeEnrollMenu(),
                    SizedBox(width: 12),
                    HomeDonationMenu(),
                    SizedBox(width: 12),
                    HomeZakatMenu(),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            SizedBox(
              height: Get.height * 0.11,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => ConditionalBuilder(
                      condition:
                          Get.find<SettingService>().isMember.value == false,
                      builder: (_) => const HomeJoinMenu(),
                      fallback: (_) => const HomeMembershipPolicyMenu(),
                    ),
                  ),
                  // SizedBox(width: 12),
                  // HomeSubscriptionMenu(),
                  const SizedBox(width: 12),
                  const HomeClaimMenu(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: Get.height * 0.11,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // HomeJoinMenu(),
                  // SizedBox(width: 12),
                  HomeDonationMenu(),
                  SizedBox(width: 12),
                  HomeZakatMenu(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeDonationMenu extends StatelessWidget {
  const HomeDonationMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (Platform.isIOS) {
                /// open safari
                Uri donationUri = Uri(
                    scheme: 'https',
                    host: 'portal.takafulcambodia.org',
                    path: '/takaful/donations');
                if (await canLaunchUrl(donationUri)) {
                  await launchUrl(donationUri,
                      mode: LaunchMode.externalApplication);
                }
              } else {
                Get.toNamed(Routes.DONATE);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wallet_giftcard,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                Text(
                  'Donation'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

class HomeZakatMenu extends StatelessWidget {
  const HomeZakatMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.ZAKAT);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calculate_outlined,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  'Zakat'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeJoinMenu extends StatelessWidget {
  const HomeJoinMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorConfig.gold,
              offset: const Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (Get.find<SettingService>().isProfileCompleted.value == true) {
                Get.toNamed(Routes.JOIN);
              } else {
                Get.toNamed(Routes.ACCOUNT);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.app_registration,
                  size: 50,
                  color: ColorConfig.gold,
                ),
                const SizedBox(height: 5),
                Text(
                  'Join'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConfig.gold,
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

class HomeEnrollMenu extends StatelessWidget {
  const HomeEnrollMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.to(() => const CreateMemberView());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.app_registration,
                  size: 50,
                  color: ColorConfig.gold,
                ),
                const SizedBox(height: 5),
                Text(
                  'Enroll'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConfig.gold,
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

class HomeClaimMenu extends StatelessWidget {
  const HomeClaimMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final AuthService auth = Get.find<AuthService>();
              if (auth.authenticated.value == false) {
                Get.toNamed(Routes.AUTH);
                return;
              }

              Get.to(() => const MembershipClaimView());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.post_add,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                Text(
                  'Claim'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

class HomeSubscriptionMenu extends StatelessWidget {
  const HomeSubscriptionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final AuthService auth = Get.find<AuthService>();
              if (auth.authenticated.value == false) {
                Get.toNamed(Routes.AUTH);
                return;
              }

              Get.to(() => const SubscriptionView());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.money,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  'Subscription'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeAccountMenu extends StatelessWidget {
  const HomeAccountMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final AuthService auth = Get.find<AuthService>();
              if (auth.authenticated.value == false) {
                Get.toNamed(Routes.AUTH);
                return;
              }

              Get.toNamed(Routes.ACCOUNT);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                Text(
                  'Account'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

class HomeAgenciesMenu extends StatefulWidget {
  const HomeAgenciesMenu({
    super.key,
  });

  @override
  State<HomeAgenciesMenu> createState() => _HomeAgenciesMenuState();
}

class _HomeAgenciesMenuState extends State<HomeAgenciesMenu> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final AuthService auth = Get.find<AuthService>();
              if (auth.authenticated.value == false) {
                Get.toNamed(Routes.AUTH);
                return;
              }

              Get.toNamed(Routes.AGENCY, arguments: {
                'isSuperAgency': true,
                'isAgency': false,
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_box_outlined,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                Text(
                  'Consultants'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

class HomeMembershipPolicyMenu extends StatefulWidget {
  const HomeMembershipPolicyMenu({
    super.key,
  });

  @override
  State<HomeMembershipPolicyMenu> createState() =>
      _HomeMembershipPolicyMenuState();
}

class _HomeMembershipPolicyMenuState extends State<HomeMembershipPolicyMenu> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: LoadingOverlay(
          isLoading: loading,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                try {
                  setState(() {
                    loading = true;
                  });

                  MemberModel? member = await MemberProvider.show(
                      Get.find<AuthService>().user.value!.uuid!);

                  if (member != null) {
                    Get.to(() => ViewMemberView(member: member));
                  }
                } finally {
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 50,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      'My Policy'.tr,
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMembersMenu extends StatelessWidget {
  const HomeMembersMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final auth = Get.find<AuthService>();
              if (auth.user.value?.roleName?.toLowerCase() == "administrator" ||
                  auth.user.value?.roleName?.toLowerCase() == "staff") {
                Get.toNamed(Routes.AGENCY, arguments: {
                  'isSuperAgency': true,
                  'isAgency': false,
                });
              } else if (auth.user.value?.roleName?.toLowerCase() ==
                  "super_agency") {
                Get.toNamed(Routes.AGENCY, arguments: {
                  'isSuperAgency': false,
                  'isAgency': true,
                  'parentUuid': auth.user.value?.uuid,
                  'parentName': auth.user.value?.name,
                });
              } else if (auth.user.value?.roleName?.toLowerCase() == "agency") {
                Get.toNamed(Routes.MEMBER, arguments: {
                  'isSuperAgency': false,
                  'isAgency': true,
                  'agencyUuid': auth.user.value?.uuid,
                  'agencyName': auth.user.value?.name,
                });
              } else {
                Get.toNamed(Routes.MEMBER, arguments: {
                  'isSuperAgency': false,
                  'isAgency': false,
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.groups,
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 5),
                Text(
                  'Members'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
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
