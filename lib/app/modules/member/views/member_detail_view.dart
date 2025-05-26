import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/member_model.dart';
import 'package:takaful/app/modules/subscription/views/create_subscription_view.dart';
import 'package:takaful/components/cached_network_image_component.dart';
import 'package:takaful/components/primary_button_component.dart';

class MemberDetailView extends StatefulWidget {
  final MemberModel member;

  const MemberDetailView({super.key, required this.member});

  @override
  State<MemberDetailView> createState() => _MemberDetailViewState();
}

class _MemberDetailViewState extends State<MemberDetailView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImageComponent(
                imageUrl: widget.member.profilePictureUrl,
                height: 120,
                width: 120,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('ID Number'.tr),
                          ),
                          Text(
                            widget.member.code ?? '__',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Subscription Amount'.tr),
                          ),
                          Text(
                            widget.member.totalPremium ?? '__',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Retire Year'.tr),
                          ),
                          Text(
                            widget.member.retirementYear ?? '__',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Khmer Name'.tr),
                  subtitle: Text(widget.member.nameKh ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('English Name'.tr),
                  subtitle: Text(widget.member.nameEn ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Gender'.tr),
                  subtitle: Text((widget.member.gender ?? '__').tr),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Identity Card'.tr),
                  subtitle: Text((widget.member.identityNumber ?? '__').tr),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Date of birth'.tr),
                  subtitle: Text(widget.member.formattedDateOfBirth ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Place of birth'.tr),
                  subtitle: Text(widget.member.placeOfBirth ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Phone'.tr),
                  subtitle: Text(widget.member.phone ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Email'.tr),
                  subtitle: Text(widget.member.email ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Occupation'.tr),
                  subtitle: Text(widget.member.occupation ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Marital Status'.tr),
                  subtitle: Text(widget.member.maritalStatus ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Family Members'.tr),
                  subtitle: Text(widget.member.email ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Address'.tr),
                  subtitle: Text(widget.member.address ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Emergency Contact'.tr),
                  subtitle: Text(widget.member.emergencyContact ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Emergency Phone'.tr),
                  subtitle: Text(widget.member.emergencyPhone ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Province'.tr),
                  subtitle: Text(widget.member.email ?? '__'),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Consultant'.tr),
                  subtitle: Text(widget.member.email ?? '__'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text('Joint date'.tr),
              subtitle: Text(widget.member.formattedJointDate ?? '__'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'តើអ្នកធ្លាប់មាន ឬកំពុងមានជំងឺប្រចាំកាយដែរឬទេ? បើមាន, តើអ្នកមានជំងឺអ្វី? *'),
                Text(widget.member.illness ?? '__'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'តើអ្នកធ្លាប់មាន ឬកំពុងមានពិការភាពដែរឬទេ? បើមាន, តើអ្នកមានពិការភាពលើអ្វី? *'),
                Text(widget.member.disability ?? '__'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Front Document'.tr,
                        style: Get.textTheme.bodySmall,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.member.frontDocumentUrl == null) {
                            return;
                          }

                          final imageProvider =
                              Image.network(widget.member.frontDocumentUrl!)
                                  .image;
                          showImageViewer(context, imageProvider,
                              onViewerDismissed: () {
                            ///
                          });
                        },
                        child: CachedNetworkImageComponent(
                          imageUrl: widget.member.frontDocumentUrl,
                          width: (Get.width / 2) - 10,
                          height: (Get.width / 2) - 10,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Back Document'.tr,
                        style: Get.textTheme.bodySmall,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.member.backDocumentUrl == null) {
                            return;
                          }

                          final imageProvider =
                              Image.network(widget.member.backDocumentUrl!)
                                  .image;
                          showImageViewer(context, imageProvider,
                              onViewerDismissed: () {
                            ///
                          });
                        },
                        child: CachedNetworkImageComponent(
                          imageUrl: widget.member.backDocumentUrl,
                          width: (Get.width / 2) - 20,
                          height: (Get.width / 2) - 20,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Note'.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                    'សមាគមអាម៉ាណះតាកាហ្វុលកម្ពុជា សូមធ្វើការរក្សាទុកនូវទិន្នន័យសមាជិកខាងលើ ដើម្បីផ្ទៀងផ្ទាត់ស្ថានភាពព័ត៌មានឬឯកសារសមាជិកជាក់ស្តែង និងធានាអោយបានថាមិនមានការក្លែងបន្លំព័ត៌មានឬឯកសារសមាជិក នៅក្នុងចេតនាអវិជ្ជមាន និងបាត់ប្រយោជន៍ដល់សមាជិកដ៏ទៃ។'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButtonComponent(
            onPressed: () async {
              await Get.to(
                  () => CreateSubscriptionView(memberId: widget.member.id));
            },
            child: Text(
              'Renew Subscription'.tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
