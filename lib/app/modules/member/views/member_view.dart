import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/member/views/view_member_view.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../configs/color_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/member_model.dart';
import '../../../data/providers/data_provider.dart';
import '../../../data/providers/member_provider.dart';
import '../controllers/member_controller.dart';
import 'create_member_view.dart';

class MemberView extends StatefulWidget {
  const MemberView({super.key});

  @override
  State<MemberView> createState() => _MemberViewState();
}

class _MemberViewState extends State<MemberView>
    with AutomaticKeepAliveClientMixin<MemberView> {
  final MemberController controller = Get.find<MemberController>();
  PagewiseLoadController<MemberModel>? pagewiseLoadController;
  bool isSearch = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final String? agencyUuid = Get.arguments['agencyUuid'];
  final String? agencyName = Get.arguments['agencyName'];

  Map<String, dynamic> membersData = {
    "members_count": 0,
    "total_subscriptions_amount": "0.00",
    "total_commissions_amount": "0.00",
  };

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => MemberProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
        agencyUuid: agencyUuid,
        params: params,
      ),
      pageSize: AppConfig.pageSize,
    );

    if (agencyUuid != null) {
      getMembersData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        pagewiseLoadController!.reset();
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: ConditionalBuilder(
            condition: agencyName != null,
            builder: (_) => Text(
              'Members of @name'.trParams({
                'name': agencyName!,
              }),
            ),
            fallback: (_) => Text('Members'.tr),
          ),
          centerTitle: false,
          actions: [
            Badge(
              isLabelVisible: isSearch == true,
              alignment: Alignment.topCenter,
              smallSize: 10,
              child: IconButton(
                onPressed: () async {
                  await searchCallback();
                },
                icon: const Icon(Icons.filter_alt),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(AppConfig.padding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.3,
                        padding: const EdgeInsets.all(AppConfig.padding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: ColorConfig.gold,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text('Members'.tr),
                            Text(
                              '${membersData['members_count'] ?? 0}',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              (agencyName ?? 'Consultant').tr,
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Subscription Amount: @amount'.trParams({
                              'amount':
                                  '${membersData['total_subscriptions_amount'] ?? 0}',
                            })),
                            Text('Commission: @amount'.trParams({
                              'amount':
                                  '${membersData['total_commissions_amount'] ?? 0}',
                            })),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConfig.padding),
                sliver: PagewiseSliverList(
                  pageLoadController: pagewiseLoadController,
                  itemBuilder: (context, MemberModel member, index) {
                    return PrimaryCardComponent(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Dismissible(
                        key: Key(member.id.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await Get.defaultDialog<bool>(
                            title: 'Delete Member'.tr,
                            middleText:
                                'Are you sure you want to delete this member?'
                                    .tr,
                            textConfirm: 'Yes'.tr,
                            textCancel: 'No'.tr,
                            confirmTextColor: Colors.white,
                            cancelTextColor: Colors.grey,
                            buttonColor: Colors.red,
                            onConfirm: () async {
                              await controller.delete(member.uuid!);
                              Get.back(result: true);
                            },
                            onCancel: () {
                              ///
                            },
                          );
                        },
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          // controller.delete(member.id);
                        },
                        child: ListTile(
                          isThreeLine: true,
                          tileColor: Colors.white,
                          onTap: () async {
                            bool? success = await Get.to(
                                () => ViewMemberView(member: member));
                            if (success == true) {
                              pagewiseLoadController!.reset();
                            }
                          },
                          leading: CachedNetworkImageComponent(
                            imageUrl: member.profilePictureUrl,
                            height: 100,
                            width: 100,
                            boxFit: BoxFit.contain,
                          ),
                          title: Text(
                            "${member.nameKh}",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text('${member.gender}'.tr),
                              // Text('@count Members'.trParams({
                              //   'count': "${member.totalMember ?? 0}",
                              // })),
                              AutoSizeText(
                                'Claimed Amount: @amount'.trParams({
                                  'amount':
                                      "${member.formattedClaimedAmount ?? 0}",
                                }),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  '[Year @year] >'.trParams({
                                    'year': "${member.subscriptionsCount}".tr,
                                  }),
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: IconButton(
                              //     icon: const Icon(Icons.edit),
                              //     onPressed: () async {
                              //       bool? success = await Get.to(
                              //           () => EditMemberView(member: member));
                              //       if (success == true) {
                              //         pagewiseLoadController!.reset();
                              //       }
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context) {
                    return const ListViewSkeletonComponent();
                  },
                  noItemsFoundBuilder: (context) {
                    return EmptyResultComponent(
                      onPressed: () {
                        pagewiseLoadController!.reset();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? success = await Get.to(() => const CreateMemberView());
            if (success == true) {
              pagewiseLoadController!.reset();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Search callback
  Future<void> searchCallback() async {
    await Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          color: Colors.white,
          child: Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              title: Text('Search'.tr),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppConfig.padding),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name'.tr,
                      contentPadding: const EdgeInsets.all(16),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone'.tr,
                      contentPadding: const EdgeInsets.all(16),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _nameController.clear();
                      _phoneController.clear();
                      pagewiseLoadController!.reset();

                      setState(() {
                        isSearch = false;
                      });
                      Get.back();
                    },
                    child: Text('Close'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> params = {};

                      if (_nameController.text.isNotEmpty) {
                        params['filter[name]'] = _nameController.text;
                      }
                      if (_phoneController.text.isNotEmpty) {
                        params['filter[phone]'] = _phoneController.text;
                      }
                      pagewiseLoadController!.reset(params: params);
                      setState(() {
                        isSearch = true;
                      });
                      Get.back();
                    },
                    child: Text('Search'.tr),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getMembersData() async {
    Map<String, dynamic> data = await DataProvider.getMembersData(
      consultantUuid: agencyUuid,
    );

    setState(() {
      membersData = data;
    });
  }
}
