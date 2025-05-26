import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/providers/data_provider.dart';
import 'package:takaful/app/routes/app_pages.dart';
import 'package:takaful/configs/color_config.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/agency_model.dart';
import '../../../data/providers/agency_provider.dart';
import '../controllers/agency_controller.dart';
import 'create_agency_view.dart';
import 'edit_agency_view.dart';

class AgencyView extends StatefulWidget {
  const AgencyView({super.key});

  @override
  State<AgencyView> createState() => _AgencyViewState();
}

class _AgencyViewState extends State<AgencyView>
    with AutomaticKeepAliveClientMixin<AgencyView> {
  final AgencyController controller = Get.find<AgencyController>();
  PagewiseLoadController<AgencyModel>? pagewiseLoadController;
  bool isSearch = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final bool isSuperAgency = Get.arguments['isSuperAgency'] ?? false;
  final bool isAgency = Get.arguments['isAgency'] ?? false;
  final String? parentUuid = Get.arguments['parentUuid'];
  final String? parentName = Get.arguments['parentName'];

  Map<String, dynamic> superConsultantsData = {
    "members_count": 0,
    "super_consultants_count": 0,
    "consultants_count": 0,
    "total_subscriptions_amount": "0.00",
  };

  Map<String, dynamic> consultantsData = {
    "members_count": 0,
    "total_subscriptions_amount": "0.00",
    "total_commissions_amount": "0.00",
  };

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => AgencyProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
        isSuperAgency: isSuperAgency,
        isAgency: isAgency,
        parentUuid: parentUuid,
        params: params,
      ),
      pageSize: AppConfig.pageSize,
    );

    getSuperConsultantsData();
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
            condition: isSuperAgency == true,
            builder: (_) => Text('Super Consultants'.tr),
            fallback: (_) => ConditionalBuilder(
              condition: parentName != null,
              builder: (_) =>
                  Text('Consultants of @name'.trParams({'name': parentName!})),
              fallback: (_) => Text('Consultants'.tr),
            ),
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
        body: CustomScrollView(
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
                child: ConditionalBuilder(
                  condition: isSuperAgency == true,
                  builder: (_) => Row(
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
                              '${superConsultantsData['members_count'] ?? 0}',
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
                            Text('Super Consultants Count: @count'.trParams({
                              'count':
                                  '${superConsultantsData['super_consultants_count'] ?? 0}',
                            })),
                            Text('Consultants Count: @count'.trParams({
                              'count':
                                  '${superConsultantsData['consultants_count'] ?? 0}',
                            })),
                            Text('Subscription Amount: @amount'.trParams({
                              'amount':
                                  '${superConsultantsData['total_subscriptions_amount'] ?? 0}',
                            })),
                          ],
                        ),
                      ),
                    ],
                  ),
                  fallback: (_) => Row(
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
                              '${consultantsData['members_count'] ?? 0}',
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
                              (parentName ?? 'Super Consultant').tr,
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Subscription Amount: @amount'.trParams({
                              'amount':
                                  '${consultantsData['total_subscriptions_amount'] ?? 0}',
                            })),
                            Text('Commission: @amount'.trParams({
                              'amount':
                                  '${consultantsData['total_commissions_amount'] ?? 0}',
                            })),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppConfig.padding),
              sliver: PagewiseSliverList(
                pageLoadController: pagewiseLoadController,
                itemBuilder: (context, AgencyModel agency, index) {
                  return PrimaryCardComponent(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Dismissible(
                      key: Key(agency.uuid.toString()),
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
                          title: 'Delete Agency'.tr,
                          middleText:
                              'Are you sure you want to delete this agency?'.tr,
                          textConfirm: 'Yes'.tr,
                          textCancel: 'No'.tr,
                          confirmTextColor: Colors.white,
                          cancelTextColor: Colors.grey,
                          buttonColor: Colors.red,
                          onConfirm: () async {
                            await controller.delete(agency.uuid!);
                            Get.back(result: true);
                          },
                          onCancel: () {
                            ///
                          },
                        );
                      },
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // controller.delete(agency.id);
                      },
                      child: ListTile(
                        tileColor: Colors.white,
                        onTap: () async {
                          if (isSuperAgency == true &&
                              agency.hasAgencies == true) {
                            Get.toNamed(
                              Routes.AGENCY,
                              arguments: {
                                'isSuperAgency': false,
                                'isAgency': true,
                                'parentUuid': agency.uuid,
                                'parentName': agency.name,
                              },
                              preventDuplicates: false,
                            );
                          } else {
                            Get.toNamed(Routes.MEMBER, arguments: {
                              'agencyUuid': agency.uuid,
                              'agencyName': agency.name,
                            });
                          }
                        },
                        leading: CachedNetworkImageComponent(
                          imageUrl: agency.profilePictureUrl,
                          height: 60,
                          width: 60,
                          boxFit: BoxFit.contain,
                        ),
                        title: Text(
                          "${agency.name}",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('[${agency.membersCount}]'),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Expanded(
                            //   child: Text(
                            //     '[${agency.membersCount}] >',
                            //     style: Get.textTheme.bodyMedium?.copyWith(
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  bool? success = await Get.to(
                                      () => EditAgencyView(agency: agency));
                                  if (success == true) {
                                    pagewiseLoadController!.reset();
                                  }
                                },
                              ),
                            ),
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
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? success = await Get.to(() => const CreateAgencyView());
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

  void getSuperConsultantsData() async {
    if (isSuperAgency == true) {
      Map<String, dynamic> data = await DataProvider.getSuperConsultantsData();
      setState(() {
        superConsultantsData = data;
      });
    } else {
      Map<String, dynamic> data = await DataProvider.getConsultantsData(
        superConsultantUuid: parentUuid,
      );

      setState(() {
        consultantsData = data;
      });
    }
  }
}
