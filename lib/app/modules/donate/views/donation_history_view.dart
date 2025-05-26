import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/donation_model.dart';
import '../../../data/providers/donation_provider.dart';
import '../controllers/donate_controller.dart';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key});

  @override
  State<DonationHistoryView> createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> {
  final DonateController controller = Get.find<DonateController>();
  PagewiseLoadController<DonationModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => DonationProvider.paginated(
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
        body: SafeArea(
          child: PagewiseListView(
            padding: const EdgeInsets.all(AppConfig.padding),
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, DonationModel donation, index) {
              return PrimaryCardComponent(
                margin: const EdgeInsets.only(bottom: 8),
                child: Dismissible(
                  key: Key(donation.id.toString()),
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
                      title: 'Delete Donation'.tr,
                      middleText: 'Are you sure you want to delete this donation?'.tr,
                      textConfirm: 'Yes'.tr,
                      textCancel: 'No'.tr,
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.grey,
                      buttonColor: Colors.red,
                      onConfirm: () async {
                        await controller.delete(donation.uuid!);
                        Get.back(result: true);
                      },
                      onCancel: () {
                        ///
                      },
                    );
                  },
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // controller.delete(donation.id);
                  },
                  child: ListTile(
                    tileColor: Colors.white,
                    title: Row(
                      children: [
                        Text(
                          "Amount: @amount".trParams({
                            'amount': "${donation.formattedAmount}",
                          }),
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(' (${donation.via ?? '__'})'),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('By: @name'.trParams({
                          'name': donation.name ?? '__',
                        })),
                        Text('Created at: @at'.trParams({
                          'at': "${donation.formattedUpdatedAt}",
                        })),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Status'.tr),
                        Text(
                          '${donation.statusLabel}',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
