import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/membership/join/controllers/join_controller.dart';
import 'package:takaful/packages/loading_overlay.dart';
import 'package:takaful/utils/catcher_util.dart';

import '../../../../../components/primary_button_component.dart';
import '../../../../../packages/form_builder_payment_method_field.dart';

class JoinView extends StatefulWidget {
  const JoinView({super.key});

  @override
  State<JoinView> createState() => _JoinViewState();
}

class _JoinViewState extends State<JoinView>
    with AutomaticKeepAliveClientMixin<JoinView>, WidgetsBindingObserver {
  final JoinController controller = Get.find<JoinController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (controller.isLoading.value == false) {
        await controller.checkTransaction();
      }
    }
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    if (controller.isLoading.value == false) {
      await controller.checkTransaction();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Join Membership'.tr),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SizedBox(
              width: Get.width,
              child: FormBuilder(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(15.0),
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Membership Fee'.tr,
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '\$25.00/${'Year'.tr}',
                      style: Get.textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const FormBuilderPaymentMethodField(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: PrimaryButtonComponent(
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.saveAndValidate()) {
                        Map<String, dynamic> data = {
                          ..._formKey.currentState!.value
                        };

                        await controller.checkout(data);
                      }
                    } catch (error, stackTrace) {
                      CatcherUtil.report(error, stackTrace);
                    }
                  },
                  child: Text(
                    'Pay Membership Fee Now'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
