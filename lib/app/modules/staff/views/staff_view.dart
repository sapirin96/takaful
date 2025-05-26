import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/staff_model.dart';
import '../../../data/providers/staff_provider.dart';
import '../controllers/staff_controller.dart';
import 'create_staff_view.dart';
import 'edit_staff_view.dart';

class StaffView extends StatefulWidget {
  const StaffView({super.key});

  @override
  State<StaffView> createState() => _StaffViewState();
}

class _StaffViewState extends State<StaffView>
    with AutomaticKeepAliveClientMixin<StaffView> {
  final StaffController controller = Get.find<StaffController>();
  PagewiseLoadController<StaffModel>? pagewiseLoadController;
  bool isSearch = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => StaffProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
        params: params,
      ),
      pageSize: AppConfig.pageSize,
    );
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
          title: Text('Staff'.tr),
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
          child: PagewiseListView(
            padding: const EdgeInsets.all(AppConfig.padding),
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, StaffModel staff, index) {
              return PrimaryCardComponent(
                margin: const EdgeInsets.only(bottom: 8),
                child: Dismissible(
                  key: Key(staff.uuid.toString()),
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
                      title: 'Delete Staff'.tr,
                      middleText:
                          'Are you sure you want to delete this staff?'.tr,
                      textConfirm: 'Yes'.tr,
                      textCancel: 'No'.tr,
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.grey,
                      buttonColor: Colors.red,
                      onConfirm: () async {
                        await controller.delete(staff.uuid!);
                        Get.back(result: true);
                      },
                      onCancel: () {
                        ///
                      },
                    );
                  },
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // controller.delete(staff.id);
                  },
                  child: ListTile(
                    tileColor: Colors.white,
                    onTap: () async {
                      bool? success =
                          await Get.to(() => EditStaffView(staff: staff));
                      if (success == true) {
                        pagewiseLoadController!.reset();
                      }
                    },
                    leading: CachedNetworkImageComponent(
                      imageUrl: staff.profilePictureUrl,
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.contain,
                    ),
                    title: Text(
                      "${staff.name}",
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${staff.gender}'),
                        Text('${staff.membersCount ?? 0} members'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        bool? success =
                            await Get.to(() => EditStaffView(staff: staff));
                        if (success == true) {
                          pagewiseLoadController!.reset();
                        }
                      },
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? success = await Get.to(() => const CreateStaffView());
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
}
