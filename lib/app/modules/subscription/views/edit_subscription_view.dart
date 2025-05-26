import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/subscription_model.dart';
import '../../../data/providers/subscription_provider.dart';

class EditSubscriptionView extends StatefulWidget {
  final SubscriptionModel subscription;

  const EditSubscriptionView({super.key, required this.subscription});

  @override
  State<EditSubscriptionView> createState() => _EditSubscriptionViewState();
}

class _EditSubscriptionViewState extends State<EditSubscriptionView>
    with AutomaticKeepAliveClientMixin<EditSubscriptionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Subscription'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: FormBuilder(
              key: _formKey,
              initialValue: widget.subscription.toJson(),
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
                      focusNode: _codeFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _ageFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _priceFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        initialValue: "${widget.subscription.code}",
                        name: 'code',
                        decoration: InputDecoration(
                          labelText: 'Code'.tr,
                          prefixIcon: const Icon(Icons.numbers),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _codeFocusNode,
                        readOnly: true,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Member name: @name".trParams({
                          'name': "${widget.subscription.memberName}",
                        }),
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Plan name: @name".trParams({
                          'name': "${widget.subscription.planName}",
                        }),
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              initialValue: "${widget.subscription.age}",
                              name: 'age',
                              decoration: InputDecoration(
                                labelText: 'Age'.tr,
                                prefixIcon: const Icon(Icons.radar),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              keyboardType: TextInputType.number,
                              focusNode: _ageFocusNode,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              initialValue: "${widget.subscription.price}",
                              name: 'price',
                              decoration: InputDecoration(
                                labelText: 'Price'.tr,
                                prefixIcon: const Icon(Icons.money_off),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              focusNode: _priceFocusNode,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              initialValue:
                                  widget.subscription.startDate != null
                                      ? DateTime.parse(
                                          widget.subscription.startDate!)
                                      : null,
                              name: 'start_date',
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'Start date'.tr,
                                prefixIcon: const Icon(Icons.calendar_month),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              enabled: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              initialValue: widget.subscription.endDate != null
                                  ? DateTime.parse(widget.subscription.endDate!)
                                  : null,
                              name: 'end_date',
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'End date'.tr,
                                prefixIcon: const Icon(Icons.calendar_month),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      FormBuilderImagePicker(
                        name: 'images',
                        decoration: InputDecoration(
                          labelText: 'Attachment'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        cameraLabel: Text('Camera'.tr),
                        galleryLabel: Text('Gallery'.tr),
                        maxImages: 10,
                      ),
                      const SizedBox(height: 15),
                      Text("@count Attachments".trParams({
                        'count':
                            "${widget.subscription.attachments?.length ?? 0}"
                      })),
                    ],
                  ),
                ),
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
                        _isLoading = true;
                      });

                      /// convert form data to FormData
                      FormData data = FormData.fromMap({
                        '_method': 'PUT',
                        ..._formKey.currentState!.value,
                      });

                      if (_formKey.currentState!.fields['images']?.value !=
                          null) {
                        /// add attachments
                        _formKey.currentState!.fields['images']!.value
                            .map((file) async {
                          data.files.add(MapEntry('attachments[]',
                              await MultipartFile.fromFile(file.path)));
                        }).toList();

                        /// remove unused images field
                        data.fields
                            .removeWhere((element) => element.key == 'images');
                      }

                      /// update subscription
                      SubscriptionModel? subscription =
                          await SubscriptionProvider.update(
                        widget.subscription.uuid!,
                        data,
                      );

                      /// check if subscription is updated
                      if (subscription?.uuid != null) {
                        Get.back(result: true);
                      }
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Text(
                  'Save'.tr,
                  style: const TextStyle(
                    color: Colors.white,
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
