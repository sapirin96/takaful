import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/home/views/partners_view.dart';
import 'package:takaful/packages/conditional_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../configs/color_config.dart';
import '../../../data/models/partner_model.dart';
import '../../../data/providers/partner_provider.dart';

class HomePartnersView extends StatefulWidget {
  const HomePartnersView({super.key});

  @override
  State<HomePartnersView> createState() => _HomePartnersViewState();
}

class _HomePartnersViewState extends State<HomePartnersView> {
  List<PartnerModel> partners = [];

  @override
  void initState() {
    _getPartners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Partners'.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Get.to(() => const PartnersView());
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
          height: 191,
          padding: const EdgeInsets.all(10),
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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: partners.map((partner) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                height: 100,
                child: InkWell(
                  onTap: () async {
                    await _onTap(partner);
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(partner.imageUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${partner.name}",
                              style: Get.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              partner.categoryName!,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ConditionalBuilder(
                        condition: partner.hasLabel == true,
                        builder: (_) => Positioned(
                          top: 0,
                          right: 0,
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
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _getPartners() async {
    List<PartnerModel> partnersResult = await PartnerProvider.get();
    setState(() {
      partners = partnersResult;
    });
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
