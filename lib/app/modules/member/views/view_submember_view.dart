import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/submember_model.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/primary_button_component.dart';
import '../../subscription/views/create_subscription_view.dart';

class ViewSubmemberView extends StatefulWidget {
  final SubmemberModel submember;

  const ViewSubmemberView({super.key, required this.submember});

  @override
  State<ViewSubmemberView> createState() => _ViewSubmemberViewState();
}

class _ViewSubmemberViewState extends State<ViewSubmemberView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Submember'.tr),
        centerTitle: false,
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Center(
              child: CachedNetworkImageComponent(
                imageUrl: widget.submember.profilePictureUrl,
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text('Khmer Name'.tr),
              trailing: Text(widget.submember.nameKh ?? '__'),
            ),
            ListTile(
              title: Text('English Name'.tr),
              trailing: Text(widget.submember.nameEn ?? '__'),
            ),
            ListTile(
              title: Text('Gender'.tr),
              trailing: Text((widget.submember.gender ?? '__').tr),
            ),
            ListTile(
              title: Text('Identity Card'.tr),
              subtitle: Text((widget.submember.identityNumber ?? '__').tr),
            ),
            ListTile(
              title: Text('Date of birth'.tr),
              subtitle: Text(widget.submember.formattedDateOfBirth ?? '__'),
            ),
            ListTile(
              title: Text('Place of birth'.tr),
              subtitle: Text(widget.submember.placeOfBirth ?? '__'),
            ),
            ListTile(
              title: Text('Phone'.tr),
              subtitle: Text(widget.submember.phone ?? '__'),
            ),
            ListTile(
              title: Text('Email'.tr),
              subtitle: Text(widget.submember.email ?? '__'),
            ),
            ListTile(
              title: Text('Address'.tr),
              subtitle: Text(widget.submember.address ?? '__'),
            ),
            ListTile(
              title: Text('Joint date'.tr),
              subtitle: Text(widget.submember.formattedJointDate ?? '__'),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Front Document'.tr),
                      CachedNetworkImageComponent(
                        imageUrl: widget.submember.frontDocumentUrl,
                        width: (Get.width / 2) - 10,
                        height: (Get.width / 2) - 10,
                        boxFit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      Text('Back Document'.tr),
                      CachedNetworkImageComponent(
                        imageUrl: widget.submember.backDocumentUrl,
                        width: (Get.width / 2) - 20,
                        height: (Get.width / 2) - 20,
                        boxFit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButtonComponent(
              onPressed: () async {
                await Get.to(() => CreateSubscriptionView(memberId: widget.submember.id));
              },
              child: Text('Renew Subscription'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
