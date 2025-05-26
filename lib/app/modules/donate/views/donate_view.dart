import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'donate_now_view.dart';
import 'donation_history_view.dart';

class DonateView extends StatefulWidget {
  const DonateView({super.key});

  @override
  State<DonateView> createState() => _DonateViewState();
}

class _DonateViewState extends State<DonateView> {
  final TabBar _tabBar = TabBar(
    indicatorColor: Colors.white,
    tabs: [
      Tab(
        text: 'Donate Now'.tr,
      ),
      Tab(
        text: 'Donation History'.tr,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donation'.tr),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.blue,
              child: _tabBar,
            ),
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              DonateNowView(),
              DonationHistoryView(),
            ],
          ),
        ),
      ),
    );
  }
}
