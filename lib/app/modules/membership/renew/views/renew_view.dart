import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/subscription_model.dart';
import 'package:takaful/app/data/providers/membership_provider.dart';
import 'package:takaful/packages/loading_overlay.dart';

import '../../../../../components/primary_button_component.dart';
import '../../../../../packages/form_builder_payment_method_field.dart';
import '../../../../../utils/catcher_util.dart';
import '../controllers/renew_controller.dart';

class RenewView extends StatefulWidget {
  const RenewView({super.key});

  @override
  State<RenewView> createState() => _RenewViewState();
}

class _RenewViewState extends State<RenewView>
    with AutomaticKeepAliveClientMixin<RenewView>, WidgetsBindingObserver {
  final RenewController controller = Get.find<RenewController>();
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

    return Obx(() => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Renew Membership'.tr),
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
                          controller.isLoading.value = true;
                          Map<String, dynamic> data = {
                            ..._formKey.currentState!.value
                          };

                          if (controller.subscription.value == null) {
                            SubscriptionModel? subscription =
                                await MembershipProvider.renew(data);

                            if (subscription?.uuid != null) {
                              controller.subscription.value = subscription;
                            }
                          }

                          if (controller.subscription.value != null) {
                            await controller.checkout(data);
                          }
                        }
                      } catch (error, stackTrace) {
                        CatcherUtil.report(error, stackTrace);
                      } finally {
                        controller.isLoading.value = false;
                      }
                    },
                    child: Text(
                      'Renew Membership Fee Now'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
