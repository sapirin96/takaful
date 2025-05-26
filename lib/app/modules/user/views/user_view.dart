import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/empty_result_component.dart';
import '../../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../../configs/app_config.dart';
import '../../../../../packages/flutter_pagewise.dart';
import '../../../../components/primary_card_component.dart';
import '../../../data/models/admin/user_model.dart';
import '../../../data/providers/admin/user_provider.dart';
import '../controllers/user_controller.dart';
import 'create_user_view.dart';
import 'edit_user_view.dart';
import 'view_user_view.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final UserController controller = Get.find<UserController>();
  PagewiseLoadController<UserModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => UserProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
      ),
      pageSize: AppConfig.pageSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        pagewiseLoadController!.reset();
        return Future.value();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Users'.tr),
            centerTitle: false,
          ),
          body: SafeArea(
            child: PagewiseListView(
              padding: const EdgeInsets.all(AppConfig.padding),
              pageLoadController: pagewiseLoadController,
              itemBuilder: (context, UserModel user, index) {
                return PrimaryCardComponent(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Dismissible(
                    key: Key(user.id.toString()),
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
                        title: 'Delete User'.tr,
                        middleText: 'Are you sure you want to delete this user?'.tr,
                        textConfirm: 'Yes'.tr,
                        textCancel: 'No'.tr,
                        onConfirm: () async {
                          await controller.delete(user.uuid!);
                          Get.back(result: true);
                        },
                        onCancel: () {
                          ///
                        },
                      );
                    },
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      // controller.delete(user.id);
                    },
                    child: ListTile(
                      tileColor: Colors.white,
                      onTap: () async {
                        await Get.to(() => ViewUserView(user: user));
                      },
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        "${user.name}",
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email ?? '__',
                            style: Get.textTheme.bodyMedium?.copyWith(),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.verified_user, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                user.role ?? '__',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          var result = await Get.to(() => EditUserView(user: user));
                          if (result != null) {
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
              bool? success = await Get.to(() => const CreateUserView());
              if (success == true) {
                pagewiseLoadController!.reset();
              }
            },
            child: const Icon(Icons.add),
          )),
    );
  }
}
