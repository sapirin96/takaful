import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/staff_model.dart';

class ViewStaffView extends StatefulWidget {
  final StaffModel staff;

  const ViewStaffView({super.key, required this.staff});

  @override
  State<ViewStaffView> createState() => _ViewStaffViewState();
}

class _ViewStaffViewState extends State<ViewStaffView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Staff'.tr),
        centerTitle: false,
      ),
    );
  }
}
