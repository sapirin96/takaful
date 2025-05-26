import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/member/views/member_detail_view.dart';

import '../../../data/models/member_model.dart';
import 'edit_member_view.dart';

class ViewMemberView extends StatefulWidget {
  final MemberModel member;

  const ViewMemberView({super.key, required this.member});

  @override
  State<ViewMemberView> createState() => _ViewMemberViewState();
}

class _ViewMemberViewState extends State<ViewMemberView> with AutomaticKeepAliveClientMixin<ViewMemberView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('View Member'.tr),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () async {
                bool? success = await Get.to(() => EditMemberView(member: widget.member));
                if (success != null && success) {
                  setState(() {});
                }
              },
              icon: const Icon(Icons.edit),
            ),
          ],
          // bottom: TabBar(
          //   indicatorColor: Colors.white,
          //   labelStyle: Get.textTheme.bodyMedium?.copyWith(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          //   unselectedLabelColor: Colors.white.withOpacity(0.5),
          //   tabs: [
          //     Tab(
          //       text: 'Detail'.tr,
          //     ),
          //     Tab(text: 'Submembers'.tr),
          //   ],
          // ),
        ),
        // body: TabBarView(
        //   children: [
        //     MemberDetailView(member: widget.member),
        //     MemberSubmembersView(member: widget.member),
        //   ],
        // ),
        body: MemberDetailView(member: widget.member),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
