import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../controllers/main_controller.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with AutomaticKeepAliveClientMixin<MainView> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (Get.arguments != null) {
        Get.find<MainController>().index.value = Get.arguments;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const HomeView();
  }

  @override
  bool get wantKeepAlive => true;
}
