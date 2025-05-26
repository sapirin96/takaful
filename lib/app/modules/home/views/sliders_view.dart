import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/slideshow_model.dart';
import 'package:takaful/app/data/providers/slideshow_provider.dart';
import 'package:takaful/components/primary_button_component.dart';
import 'package:takaful/components/primary_card_component.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';

class SlidersView extends StatefulWidget {
  const SlidersView({super.key});

  @override
  State<SlidersView> createState() => _SlidersViewState();
}

class _SlidersViewState extends State<SlidersView> {
  PagewiseLoadController<SlideShowModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (pageIndex, params) => SlideShowProvider.paginated(
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
          title: Text('News & Promotions'.tr),
        ),
        body: SafeArea(
          child: PagewiseListView(
            pageLoadController: pagewiseLoadController,
            itemBuilder: (context, SlideShowModel slide, index) {
              return InkWell(
                onTap: () {
                  _onTap(slide);
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
                        CachedNetworkImageComponent(
                          imageUrl: slide.imageUrl,
                          height: 150,
                          width: double.infinity,
                          boxFit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: HtmlWidget(
                            "${slide.description}",
                          ),
                        ),
                        PrimaryButtonComponent(
                          onPressed: () {
                            _onTap(slide);
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

  _launchURL(String url) async {
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

  void _onTap(SlideShowModel slide) async {
    if (slide.uuid == null) return;

    bool? success = await SlideShowProvider.count(uuid: slide.uuid!);

    if (success == true) {
      _launchURL('${slide.callbackUrl}');
    }
  }
}
