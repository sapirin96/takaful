import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/partner_model.dart';
import 'package:takaful/app/data/providers/partner_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/primary_button_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/flutter_pagewise.dart';

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView> {
  PagewiseLoadController<PartnerModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (pageIndex, params) => PartnerProvider.paginated(
        page: pageIndex! + 1,
        limit: AppConfig.pageSize,
      ),
      pageSize: AppConfig.pageSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        pagewiseLoadController!.reset();
        return Future.value();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Partners'.tr),
        ),
        body: SafeArea(
          child: PagewiseListView(
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, PartnerModel partner, index) {
              return InkWell(
                onTap: () async {
                  await _onTap(partner);
                },
                child: PrimaryCardComponent(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 12,
                    right: 12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImageComponent(
                              imageUrl: partner.imageUrl,
                              height: 150,
                              width: double.infinity,
                              boxFit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${partner.discountPercentage} OFF',
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${partner.name}",
                                  style: Get.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Chip(
                                avatar: const Icon(
                                  Icons.local_offer,
                                ),
                                label: Text("${partner.categoryName}"),
                              ),
                            ],
                          ),
                        ),
                        ConditionalBuilder(
                          condition: partner.description != null,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: HtmlWidget(
                              partner.description!,
                              textStyle: Get.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        PrimaryButtonComponent(
                          onPressed: () async {
                            await _onTap(partner);
                          },
                          child: Text(
                            'View Details'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(PartnerModel partner) async {
    if (partner.uuid == null) return;

    bool? success = await PartnerProvider.count(uuid: partner.uuid!);

    if (success == true) {
      await _launchURL('${partner.url}');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      final bool nativeAppLaunchSucceeded = await launchUrl(
        Uri.parse(url),
      );
      if (!nativeAppLaunchSucceeded) {
        await launchUrl(
          Uri.parse(url),
        );
      }
    }
  }
}
