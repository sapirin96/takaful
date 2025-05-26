import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/member/views/create_submember_view.dart';
import 'package:takaful/app/modules/member/views/edit_submember_view.dart';
import 'package:takaful/app/modules/member/views/view_submember_view.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/member_model.dart';
import '../../../data/models/submember_model.dart';
import '../../../data/providers/submember_provider.dart';
import '../controllers/member_controller.dart';

class MemberSubmembersView extends StatefulWidget {
  final MemberModel member;
  const MemberSubmembersView({super.key, required this.member});

  @override
  State<MemberSubmembersView> createState() => _MemberSubmembersViewState();
}

class _MemberSubmembersViewState extends State<MemberSubmembersView> with AutomaticKeepAliveClientMixin<MemberSubmembersView> {
  final MemberController controller = Get.find<MemberController>();
  PagewiseLoadController<SubmemberModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => SubmemberProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
        memberId: widget.member.id,
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
        body: SafeArea(
          child: PagewiseListView(
            padding: const EdgeInsets.all(AppConfig.padding),
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, SubmemberModel submember, index) {
              return PrimaryCardComponent(
                margin: const EdgeInsets.only(bottom: 8),
                child: Dismissible(
                  key: Key(submember.id.toString()),
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
                      middleText: 'Are you sure you want to delete this member?'.tr,
                      textConfirm: 'Yes'.tr,
                      textCancel: 'No'.tr,
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.grey,
                      buttonColor: Colors.red,
                      onConfirm: () async {
                        await controller.delete(submember.uuid!);
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
                      bool? success = await Get.to(() => ViewSubmemberView(submember: submember));
                      if (success == true) {
                        pagewiseLoadController!.reset();
                      }
                    },
                    leading: CachedNetworkImageComponent(
                      imageUrl: submember.profilePictureUrl,
                      height: 60,
                      width: 60,
                      boxFit: BoxFit.contain,
                    ),
                    title: Text(
                      "${submember.nameKh}",
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Claimed Amount: @amount'.trParams({
                            'amount': "${submember.formattedClaimedAmount ?? 0}",
                          }),
                          maxLines: 1,
                        ),
                        Text('Subscription Years: @years'.trParams({
                          'years': "${submember.subscriptionsCount ?? 0}",
                        })),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text('Gender: @gender'.trParams({
                            'gender': "${submember.gender}".tr,
                          })),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              bool? success = await Get.to(() => EditSubmemberView(submember: submember));
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? success = await Get.to(() => CreateSubmemberView(member: widget.member));
            if (success == true) {
              pagewiseLoadController!.reset();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
