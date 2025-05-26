import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/claim_model.dart';

class ViewClaimView extends StatefulWidget {
  final ClaimModel claim;

  const ViewClaimView({super.key, required this.claim});

  @override
  State<ViewClaimView> createState() => _ViewClaimViewState();
}

class _ViewClaimViewState extends State<ViewClaimView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Claim'.tr),
        centerTitle: false,
      ),
    );
  }
}
