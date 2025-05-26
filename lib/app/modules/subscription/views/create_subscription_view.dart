import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/subscription_model.dart';
import '../../../data/providers/data_provider.dart';
import '../../../data/providers/subscription_provider.dart';

class CreateSubscriptionView extends StatefulWidget {
  final int? memberId;

  const CreateSubscriptionView({super.key, this.memberId});

  @override
  State<CreateSubscriptionView> createState() => _CreateSubscriptionViewState();
}

class _CreateSubscriptionViewState extends State<CreateSubscriptionView>
    with AutomaticKeepAliveClientMixin<CreateSubscriptionView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  bool _isLoading = false;
  bool _loadingMembers = false;
  bool _loadingPlans = false;

  List<Map<String, dynamic>> members = [];
  List<Map<String, dynamic>> plans = [];

  @override
  void initState() {
    if (widget.memberId == null) {
      _getMembers();
    } else {
      _getNextSubscription();
    }
    _getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Subscription'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
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
                      ConditionalBuilder(
                        condition: widget.memberId == null,
                        builder: (_) => FormBuilderDropdown(
                          name: 'member_id',
                          decoration: InputDecoration(
                            labelText: 'Choose a member'.tr,
                            prefixIcon: _loadingMembers == true
                                ? Container(
                                    padding: const EdgeInsets.all(12),
                                    width: 30,
                                    height: 30,
                                    child: const CircularProgressIndicator(),
                                  )
                                : const Icon(Icons.account_box_outlined),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required'.tr),
                          ]),
                          items: members.map((member) {
                            return DropdownMenuItem(
                              value: member['value'],
                              child: Text(member['title']),
                            );
                          }).toList(),
                        ),
                      ),
                      FormBuilderDropdown(
                        name: 'plan_id',
                        decoration: InputDecoration(
                          labelText: 'Choose a plan'.tr,
                          prefixIcon: _loadingPlans == true
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  width: 30,
                                  height: 30,
                                  child: const CircularProgressIndicator(),
                                )
                              : const Icon(Icons.file_open),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        items: plans.map((member) {
                          return DropdownMenuItem(
                            value: member['id'],
                            child: Text(member['name']),
                          );
                        }).toList(),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
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
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
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
                              initialValue: DateTime.now(),
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              onChanged: (value) {
                                if (value != null) {
                                  _formKey.currentState?.fields['end_date']
                                      ?.didChange(
                                          value.add(const Duration(days: 364)));
                                }
                              },
                              enabled: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDateTimePicker(
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
                        maxImages: 10,
                        cameraLabel: Text('Camera'.tr),
                        galleryLabel: Text('Gallery'.tr),
                      ),
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
                        ..._formKey.currentState!.value,
                      });

                      /// add member id if it's not null
                      if (widget.memberId != null) {
                        data.fields.add(
                            MapEntry('member_id', widget.memberId.toString()));
                      }

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

                      /// create subscription
                      SubscriptionModel? subscription =
                          await SubscriptionProvider.store(
                        data,
                      );

                      /// check if subscription is created
                      if (subscription?.uuid != null) {
                        Get.back(result: true);
                      }
                    }
                  } catch (error) {
                    Get.rawSnackbar(message: error.toString());
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

  /// get next subscription
  Future<void> _getNextSubscription() async {
    try {
      setState(() => _isLoading = true);
      await DataProvider.nextSubscriptionDate(memberId: widget.memberId)
          .then((value) {
        /// set plan id
        if (value.containsKey('plan_id')) {
          _formKey.currentState!.fields['plan_id']!.didChange(value['plan_id']);
        }

        /// set age
        if (value.containsKey('age')) {
          _formKey.currentState!.fields['age']!.didChange("${value['age']}");
        }

        /// set price
        if (value.containsKey('price')) {
          _formKey.currentState!.fields['price']!
              .didChange("${value['price']}");
        }

        /// set start date
        if (value.containsKey('start_date')) {
          _formKey.currentState!.fields['start_date']!
              .didChange(DateTime.parse(value['start_date']));
        }

        /// set end date
        if (value.containsKey('end_date')) {
          _formKey.currentState!.fields['end_date']!
              .didChange(DateTime.parse(value['end_date']));
        }
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// get members
  Future<void> _getMembers() async {
    try {
      setState(() => _loadingMembers = true);
      await DataProvider.members().then((value) {
        setState(() {
          members = value;
        });
      });
    } finally {
      setState(() => _loadingMembers = false);
    }
  }

  /// get plans
  Future<void> _getPlans() async {
    try {
      setState(() => _loadingPlans = true);
      await DataProvider.plans().then((value) {
        setState(() {
          plans = value;
        });

        /// if there is only one plan, select it
        if (plans.length == 1) {
          _formKey.currentState!.fields['plan_id']!
              .didChange(plans.first['id']);
        }
      });
    } finally {
      setState(() => _loadingPlans = false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
