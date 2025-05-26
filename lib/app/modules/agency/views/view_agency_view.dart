import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/agency_model.dart';

class ViewAgencyView extends StatefulWidget {
  final AgencyModel agency;

  const ViewAgencyView({super.key, required this.agency});

  @override
  State<ViewAgencyView> createState() => _ViewAgencyViewState();
}

class _ViewAgencyViewState extends State<ViewAgencyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Consultant'.tr),
        centerTitle: false,
      ),
    );
  }
}
