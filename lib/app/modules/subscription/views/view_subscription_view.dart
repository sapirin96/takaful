import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/subscription_model.dart';

class ViewSubscriptionView extends StatefulWidget {
  final SubscriptionModel subscription;

  const ViewSubscriptionView({super.key, required this.subscription});

  @override
  State<ViewSubscriptionView> createState() => _ViewSubscriptionViewState();
}

class _ViewSubscriptionViewState extends State<ViewSubscriptionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Subscription'.tr),
        centerTitle: false,
      ),
    );
  }
}
