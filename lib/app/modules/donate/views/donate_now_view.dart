import 'package:auto_size_text/auto_size_text.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takaful/app/data/models/bank_account_model.dart';
import 'package:takaful/app/modules/donate/controllers/donate_controller.dart';
import 'package:takaful/app/services/auth_service.dart';

import '../../../../components/cached_network_image_component.dart';
import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../configs/color_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/form_builder_payment_method_field.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/donation_model.dart';
import '../../../data/providers/donation_provider.dart';

class DonateNowView extends StatefulWidget {
  const DonateNowView({super.key});

  @override
  State<DonateNowView> createState() => _DonateNowViewState();
}

class _DonateNowViewState extends State<DonateNowView> with AutomaticKeepAliveClientMixin<DonateNowView>, WidgetsBindingObserver {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final DonateController controller = Get.find<DonateController>();
  final TextEditingController _amountTextEditingController = TextEditingController();

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

  Future<bool> myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) async {
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
          body: SizedBox(
            width: Get.width,
            child: FormBuilder(
              key: _formKey,
              child: KeyboardActions(
                tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
                config: KeyboardActionsConfig(
                  keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                  keyboardBarColor: Colors.grey[200],
                  defaultDoneWidget: Text(
                    'Done'.tr,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  actions: [
                    KeyboardActionsItem(
                      focusNode: _nameFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _phoneFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _amountFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Thanks for donating'.tr,
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Please fill your donation amount below'.tr,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => FormBuilderTextField(
                                    initialValue: Get.find<AuthService>().user.value?.name,
                                    name: 'name',
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      label: Text('Name'.tr),
                                      hintText: 'Enter your name'.tr,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'This field is required'.tr),
                                    ]),
                                    focusNode: _nameFocusNode,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => FormBuilderTextField(
                                    initialValue: Get.find<AuthService>().user.value?.phone,
                                    name: 'phone',
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      label: Text('Phone Number'.tr),
                                      hintText: 'Enter your phone number'.tr,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'This field is required'.tr),
                                    ]),
                                    focusNode: _phoneFocusNode,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FormBuilderTextField(
                            name: 'amount',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              label: Text('Amount in USD(\$)'.tr),
                              hintText: 'The minimum amount is \$1'.tr,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'This field is required'.tr),
                              FormBuilderValidators.min(1),
                              FormBuilderValidators.max(1000),
                            ]),
                            controller: _amountTextEditingController,
                            focusNode: _amountFocusNode,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Or choose donation amount'.tr,
                              style: Get.textTheme.bodyMedium,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 1.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 5.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 10.00,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 20.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 50.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 100.00,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 200.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 500.00,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DonateAmountButtonWidget(
                                  amountTextEditingController: _amountTextEditingController,
                                  amount: 1000.00,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilderPaymentMethodField(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(AppConfig.padding),
              child: SafeArea(
                child: PrimaryButtonComponent(
                  height: 50,
                  onPressed: () async {
                    try {
                      if (_formKey.currentState!.saveAndValidate()) {
                        setState(() {
                          controller.isLoading.value = true;
                        });

                        /// convert form data to FormData
                        Map<String, dynamic> data = {
                          ..._formKey.currentState!.value,
                        };

                        if (controller.donation.value == null) {
                          /// create donation
                          DonationModel? donation = await DonationProvider.store(
                            data,
                          );

                          if (donation?.uuid != null) {
                            controller.donation.value = donation;
                          }
                        }

                        if (controller.donation.value?.uuid != null) {
                          await controller.checkout(data);
                        }
                      }
                    } finally {
                      setState(() {
                        controller.isLoading.value = false;
                      });
                    }
                  },
                  child: Text('Donate Now'.tr),
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

class FormBuilderDonationAccountField extends StatelessWidget {
  const FormBuilderDonationAccountField({
    super.key,
    required Future<List<BankAccountModel>?>? bankAccountsFuture,
  }) : _bankAccountsFuture = bankAccountsFuture;

  final Future<List<BankAccountModel>?>? _bankAccountsFuture;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: 'donation_account_id',
      validator: FormBuilderValidators.required(errorText: 'This field is required'.tr),
      builder: (FormFieldState<dynamic> field) {
        return InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(0),
            errorText: field.errorText,
          ),
          child: FutureBuilder<List<BankAccountModel>?>(
            future: _bankAccountsFuture,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((account) {
                    bool isActive = field.value == account.id;

                    return Opacity(
                      opacity: account.active == true ? 1 : 0.5,
                      child: Container(
                        margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isActive ? ColorConfig.blue : ColorConfig.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: isActive ? (Get.isDarkMode ? Colors.transparent : Colors.blueGrey.shade50) : Colors.transparent,
                        ),
                        child: Center(
                          child: ListTile(
                            onTap: () {
                              field.didChange(account.id);
                            },
                            leading: CachedNetworkImageComponent(
                              imageUrl: account.imageUrl,
                              width: 60,
                              height: 60,
                              circular: 8,
                              boxFit: BoxFit.contain,
                            ),
                            minLeadingWidth: 60,
                            title: AutoSizeText(
                              "${account.name}",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              minFontSize: 9,
                              maxFontSize: 12,
                            ),
                            subtitle: Text(
                              "${account.description}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: SizedBox(
                              width: 25,
                              height: 25,
                              child: ConditionalBuilder(
                                condition: isActive,
                                builder: (_) => Icon(
                                  Icons.radio_button_checked_outlined,
                                  color: ColorConfig.blue,
                                ),
                                fallback: (_) => const Icon(Icons.radio_button_unchecked_outlined),
                              ),
                            ),
                            selected: isActive,
                            enabled: account.active == true,
                            isThreeLine: false,
                            horizontalTitleGap: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }

              return Container();
            }),
          ),
        );
      },
    );
  }
}

class DonateAmountButtonWidget extends StatelessWidget {
  final double amount;

  const DonateAmountButtonWidget({
    super.key,
    required TextEditingController amountTextEditingController,
    required this.amount,
  })  : _amountTextEditingController = amountTextEditingController;

  final TextEditingController _amountTextEditingController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _amountTextEditingController.text = amount.toStringAsFixed(2);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Text(
        '\$${amount.toStringAsFixed(2)}'.tr,
        style: Get.textTheme.labelLarge?.copyWith(
          color: Colors.black,
        ),
      ),
    );
  }
}
