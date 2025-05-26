import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/admin/user_model.dart';

class ViewUserView extends StatefulWidget {
  final UserModel user;

  const ViewUserView({super.key, required this.user});

  @override
  State<ViewUserView> createState() => _ViewUserViewState();
}

class _ViewUserViewState extends State<ViewUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Name'.tr),
            trailing: Text('${widget.user.name}'),
          ),
          ListTile(
            title: Text('Email'.tr),
            trailing: Text('${widget.user.email}'),
          ),
          ListTile(
            title: Text('Role'.tr),
            trailing: Text("${widget.user.role}"),
          ),
        ],
      ),
    );
  }
}
