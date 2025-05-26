import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/home/views/sliders_view.dart';
import 'package:takaful/packages/conditional_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../configs/color_config.dart';
import '../../../data/models/slideshow_model.dart';
import '../../../data/providers/slideshow_provider.dart';

class HomeCarouselView extends StatefulWidget {
  const HomeCarouselView({super.key});

  @override
  State<HomeCarouselView> createState() => _HomeCarouselViewState();
}

class _HomeCarouselViewState extends State<HomeCarouselView> with AutomaticKeepAliveClientMixin<HomeCarouselView> {
  Future<List<SlideShowModel>>? slideShowFuture;

  @override
  void initState() {
    super.initState();
    slideShowFuture = SlideShowProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'News & Promotions'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Get.to(() => const SlidersView());
              },
              child: Row(
                children: [
                  Text(
                    'View All'.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: ColorConfig.gold,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 150,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: FutureBuilder<List<SlideShowModel>>(
              future: slideShowFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SlideShowModel>? slideShows = snapshot.data;
                  return CarouselSlider(
                    items: slideShows?.map((item) {
                      return GestureDetector(
                        onTap: () async {
                          if (item.uuid == null) return;

                          bool? success = await SlideShowProvider.count(uuid: item.uuid!);

                          if (success == true) {
                            _launchURL('${item.callbackUrl}');
                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CachedNetworkImageComponent(
                              imageUrl: item.imageUrl,
                              boxFit: BoxFit.cover,
                              circular: 0,
                            ),
                            ConditionalBuilder(
                              condition: item.excerpt != null,
                              builder: (_) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConfig.blue.withOpacity(0.7),
                                  ),
                                  child: Text(
                                    '${item.excerpt}',
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: ColorConfig.white,
                                          height: 1.5,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 250,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      viewportFraction: 1,
                      aspectRatio: 16 / 10,
                      disableCenter: true,
                      initialPage: 1,
                      pageSnapping: true,
                      scrollDirection: Axis.horizontal,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
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

  @override
  bool get wantKeepAlive => true;
}
