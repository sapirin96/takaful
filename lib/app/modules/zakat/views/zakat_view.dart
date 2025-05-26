import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/zakat/views/view_zakat_view.dart';

import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/zakat_model.dart';
import '../../../data/providers/zakat_provider.dart';
import '../controllers/zakat_controller.dart';
import 'create_zakat_view.dart';

class ZakatView extends StatefulWidget {
  const ZakatView({super.key});

  @override
  State<ZakatView> createState() => _ZakatViewState();
}

class _ZakatViewState extends State<ZakatView> {
  final ZakatController controller = Get.find<ZakatController>();
  PagewiseLoadController<ZakatModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => ZakatProvider.paginated(
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
          title: Text('Zakat'.tr),
        ),
        body: SafeArea(
          child: PagewiseListView(
            padding: const EdgeInsets.all(AppConfig.padding),
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, ZakatModel zakat, index) {
              return PrimaryCardComponent(
                margin: const EdgeInsets.only(bottom: 8),
                child: Dismissible(
                  key: Key(zakat.id.toString()),
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
                      title: 'Delete Zakat'.tr,
                      middleText: 'Are you sure you want to delete this zakat?'.tr,
                      textConfirm: 'Yes'.tr,
                      textCancel: 'No'.tr,
                      confirmTextColor: Colors.white,
                      cancelTextColor: Colors.grey,
                      buttonColor: Colors.red,
                      onConfirm: () async {
                        await controller.delete(zakat.uuid!);
                        Get.back(result: true);
                      },
                      onCancel: () {
                        ///
                      },
                    );
                  },
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // controller.delete(zakat.id);
                  },
                  child: ListTile(
                    isThreeLine: true,
                    tileColor: Colors.white,
                    onTap: () async {
                      bool? success = await Get.to(() => ViewZakatView(zakat: zakat));
                      if (success == true) {
                        pagewiseLoadController!.reset();
                      }
                    },
                    title: Text(
                      "Asset: @amount".trParams({
                        'amount': "\$${zakat.asset}",
                      }),
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('By: @name'.trParams({
                          'name': zakat.name ?? '__',
                        })),
                        Text('Updated at: @at'.trParams({
                          'at': "${zakat.formattedUpdatedAt}",
                        })),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Zakat'.tr),
                        Text(
                          '\$${zakat.zakat}',
                          style: Get.textTheme.titleMedium?.copyWith(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? success = await Get.to(() => const CreateZakatView());
            if (success == true) {
              pagewiseLoadController!.reset();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
