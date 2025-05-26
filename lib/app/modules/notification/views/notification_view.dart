import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../configs/color_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/providers/notification_provider.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> with AutomaticKeepAliveClientMixin<NotificationView> {
  final NotificationController controller = Get.find<NotificationController>();

  late PagewiseLoadController<NotificationModel> pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => NotificationProvider.getNotification(
        page: index! + 1,
        limit: AppConfig.pageSize,
      ),
      pageSize: AppConfig.pageSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'.tr),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          padding: AppConfig.containerPadding,
          child: PagewiseListView(
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, NotificationModel notification, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: PrimaryCardComponent(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "${notification.title}",
                            style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConfig.gold,
                                ),
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            "${notification.createdAt}",
                            style: TextStyle(color: ColorConfig.gold),
                            maxLines: 2,
                          ),
                          dense: true,
                        ),
                        HtmlWidget(
                          '${notification.body}',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            noItemsFoundBuilder: (context) => EmptyResultComponent(
              onPressed: () {
                pagewiseLoadController.reset();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
