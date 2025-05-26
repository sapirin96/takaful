import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../components/empty_result_component.dart';
import '../../../../components/primary_card_component.dart';
import '../../../../components/skeletons/list_view_skeleton_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/flutter_pagewise.dart';
import '../../../data/models/claim_model.dart';
import '../../../data/providers/claim_provider.dart';
import '../../claim/views/create_claim_view.dart';
import '../../claim/views/edit_claim_view.dart';

class MembershipClaimView extends StatefulWidget {
  const MembershipClaimView({super.key});

  @override
  State<MembershipClaimView> createState() => _MembershipClaimViewState();
}

class _MembershipClaimViewState extends State<MembershipClaimView> {
  PagewiseLoadController<ClaimModel>? pagewiseLoadController;

  @override
  void initState() {
    pagewiseLoadController = PagewiseLoadController(
      pageFuture: (index, params) => ClaimProvider.paginated(
        page: index! + 1,
        perPage: AppConfig.pageSize,
      ),
      pageSize: AppConfig.pageSize,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PagewiseListView(
          padding: const EdgeInsets.all(AppConfig.padding),
          pageLoadController: pagewiseLoadController,
          itemBuilder: (context, ClaimModel claim, index) {
            return PrimaryCardComponent(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                isThreeLine: true,
                tileColor: Colors.white,
                onTap: () async {
                  bool? success = await Get.to(() => EditClaimView(claim: claim));
                  if (success == true) {
                    pagewiseLoadController!.reset();
                  }
                },
                title: Text(
                  "${claim.memberName}",
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Amount: @amount'.trParams({
                      'amount': "${claim.formattedCompensation} (${claim.formattedCompensationKhr})",
                    })),
                    Text('Type: @type'.trParams({
                      'type': "${claim.formattedType}",
                    })),
                    Text('${claim.formattedDate}'),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Chip(
                        label: Text(
                          "${claim.statusLabel}",
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: HexColor(claim.statusColor ?? '#595959'),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          bool? success = await Get.to(() => EditClaimView(claim: claim));
                          if (success == true) {
                            pagewiseLoadController!.reset();
                          }
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? success = await Get.to(() => const CreateClaimView());
          if (success == true) {
            pagewiseLoadController!.reset();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
