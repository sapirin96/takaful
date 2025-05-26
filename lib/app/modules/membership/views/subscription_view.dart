import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/routes/app_pages.dart';

import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_button_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/subscription_model.dart';
import '../../../data/providers/subscription_provider.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView>
    with AutomaticKeepAliveClientMixin<SubscriptionView> {
  PagewiseLoadController<SubscriptionModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => SubscriptionProvider.paginated(
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
          title: Text('Subscription'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: PagewiseListView(
            padding: const EdgeInsets.all(AppConfig.padding),
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, SubscriptionModel subscription, index) {
              return PrimaryCardComponent(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    "${subscription.memberName}",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          '${subscription.formattedStartDate} => ${subscription.formattedEndDate}'),
                      Text('Amount: @amount'.trParams({
                        'amount': "${subscription.formattedPrice ?? 0}",
                      })),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${subscription.code}",
                        ),
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.zero,
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          width: Get.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: PrimaryButtonComponent(
                onPressed: () {
                  Get.toNamed(Routes.RENEW);
                },
                child: Text(
                  'Renew Membership'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
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
