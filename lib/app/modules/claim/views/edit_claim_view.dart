import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/claim_model.dart';
import '../../../data/providers/claim_provider.dart';
import '../../../data/providers/data_provider.dart';

class EditClaimView extends StatefulWidget {
  final ClaimModel claim;

  const EditClaimView({super.key, required this.claim});

  @override
  State<EditClaimView> createState() => _EditClaimViewState();
}

class _EditClaimViewState extends State<EditClaimView>
    with AutomaticKeepAliveClientMixin<EditClaimView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _placeOfDeathFocusNode = FocusNode();
  final FocusNode _describeReasonOfDeathFocusNode = FocusNode();
  final FocusNode _placeOfIncidentFocusNode = FocusNode();
  final FocusNode _describeReasonOfDisablementFocusNode = FocusNode();
  final FocusNode _compensateInUSDFocusNode = FocusNode();
  final FocusNode _compensateInKHRFocusNode = FocusNode();
  final FocusNode _hospitalNameFocusNode = FocusNode();
  final FocusNode _doctorNameFocusNode = FocusNode();
  final FocusNode _doctorPhoneFocusNode = FocusNode();
  final FocusNode _doctorEmailFocusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();

  final TextEditingController compensationUSDEditingController =
      TextEditingController();
  final TextEditingController compensationKHREditingController =
      TextEditingController();

  List<Map<String, dynamic>> policies = [];
  final List<Map<String, dynamic>> types = [
    {
      "value": "dead",
      "title": "Dead".tr,
    },
    {
      "value": "disabled",
      "title": "Permanent Disablement".tr,
    },
    {
      "value": "overaged",
      "title": "Overaged".tr,
    },
  ];
  final List<Map<String, dynamic>> deadTypes = [
    {
      "value": "dead_by_accident",
      "title": "Accident".tr,
    },
    {
      "value": "dead_by_illness",
      "title": "Illness".tr,
    },
    {
      "value": "dead_by_covid19",
      "title": "Covid-19".tr,
    },
  ];
  final List<Map<String, dynamic>> durations = [
    {
      "value": "one_month",
      "title": "Below 1 month".tr,
    },
    {
      "value": "one_to_three_months",
      "title": "1 to 3 months".tr,
    },
    {
      "value": "three_to_six_months",
      "title": "3 to 6 months".tr,
    },
    {
      "value": "over_six_months",
      "title": "Over 6 months".tr,
    },
  ];

  bool _isLoading = false;
  bool _loadingPolicies = false;

  String? _type;

  @override
  void initState() {
    _getPolicies();
    setState(() {
      _type = widget.claim.type;
    });
    compensationKHREditingController.text =
        widget.claim.compensationKhr.toString();
    compensationUSDEditingController.text =
        widget.claim.compensation.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Claim'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: FormBuilder(
              key: _formKey,
              initialValue: widget.claim.toJson(),
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
                      focusNode: _placeOfDeathFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _describeReasonOfDeathFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _placeOfIncidentFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _describeReasonOfDisablementFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _compensateInUSDFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _compensateInKHRFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _hospitalNameFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _doctorNameFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _doctorPhoneFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _doctorEmailFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _commentFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        initialValue: widget.claim.date != null
                            ? DateTime.parse(widget.claim.date!)
                            : null,
                        name: 'date',
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: 'Date'.tr,
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          "Member name: @name".trParams({
                            'name': "${widget.claim.memberName}",
                          }),
                          style: Get.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FormBuilderDropdown(
                        name: 'type',
                        items: types.map((type) {
                          return DropdownMenuItem(
                            value: type['value'],
                            child: Text(type['title']),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Type'.tr,
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        onChanged: (value) async {
                          setState(() {
                            _type = value as String?;
                          });
                          await _getCompensation();
                        },
                      ),
                      const SizedBox(height: 20),
                      ConditionalBuilder(
                        condition: _type == 'dead',
                        builder: (_) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                          ),
                          child: Column(
                            children: [
                              FormBuilderDropdown(
                                name: 'reasons_of_death',
                                items: deadTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type['value'],
                                    child: Text(type['title']),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Reasons of death'.tr,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                onChanged: (value) async {
                                  await _getCompensation();
                                },
                              ),
                              FormBuilderDateTimePicker(
                                initialValue: widget.claim.dateOfDeath != null
                                    ? DateTime.parse(widget.claim.dateOfDeath!)
                                    : null,
                                name: 'date_of_death',
                                inputType: InputType.date,
                                decoration: InputDecoration(
                                  labelText: 'Date of death'.tr,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'place_of_death_or_accident',
                                decoration: InputDecoration(
                                  labelText: 'Place of death or accident'.tr,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                focusNode: _placeOfDeathFocusNode,
                              ),
                              FormBuilderTextField(
                                name: 'please_describe_the_reason_of_death',
                                decoration: InputDecoration(
                                  labelText:
                                      'Please describe the reason of death:'.tr,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                focusNode: _describeReasonOfDeathFocusNode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ConditionalBuilder(
                        condition: _type == 'disabled',
                        builder: (_) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                          ),
                          child: Column(
                            children: [
                              FormBuilderDropdown(
                                name: 'policy_id',
                                items: policies.map((member) {
                                  return DropdownMenuItem(
                                    value: member['value'],
                                    child: Text(member['title']),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Body parts that are disabled'.tr,
                                  prefixIcon: _loadingPolicies == true
                                      ? Container(
                                          padding: const EdgeInsets.all(12),
                                          width: 30,
                                          height: 30,
                                          child:
                                              const CircularProgressIndicator(),
                                        )
                                      : null,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                onChanged: (value) async {
                                  await _getCompensation();
                                },
                              ),
                              FormBuilderTextField(
                                name: 'place_of_issues',
                                decoration: InputDecoration(
                                  labelText: 'Place of issues'.tr,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                focusNode: _placeOfIncidentFocusNode,
                              ),
                              FormBuilderDateTimePicker(
                                initialValue:
                                    widget.claim.dateOfDisablement != null
                                        ? DateTime.parse(
                                            widget.claim.dateOfDisablement!)
                                        : null,
                                name: 'date_of_disablement',
                                inputType: InputType.date,
                                decoration: InputDecoration(
                                  labelText: 'Date of disablement'.tr,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'disablement_reason',
                                decoration: InputDecoration(
                                  labelText: "Disablement's reason".tr,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'This field is required'.tr),
                                ]),
                                focusNode:
                                    _describeReasonOfDisablementFocusNode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'compensation',
                              controller: compensationUSDEditingController,
                              decoration: InputDecoration(
                                labelText: 'Compensation in USD'.tr,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              focusNode: _compensateInUSDFocusNode,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'compensation_khr',
                              controller: compensationKHREditingController,
                              decoration: InputDecoration(
                                labelText: 'Compensation in KHR'.tr,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              focusNode: _compensateInKHRFocusNode,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ConditionalBuilder(
                        condition: _type == 'dead' || _type == 'disabled',
                        builder: (_) => Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'hospital_address',
                                decoration: InputDecoration(
                                  labelText: 'Hospital Address'.tr,
                                ),
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _hospitalNameFocusNode,
                              ),
                              FormBuilderTextField(
                                name: 'doctor_name',
                                decoration: InputDecoration(
                                  labelText: 'Doctor Name'.tr,
                                ),
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _doctorNameFocusNode,
                              ),
                              FormBuilderPhoneField(
                                name: 'doctor_phone',
                                decoration: InputDecoration(
                                  labelText: 'Doctor Phone'.tr,
                                ),
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _doctorPhoneFocusNode,
                                countryFilterByIsoCode: const ['KH'],
                                priorityListByIsoCode: const ['KH'],
                                defaultSelectedCountryIsoCode: 'KH',
                              ),
                              FormBuilderTextField(
                                name: 'doctor_email',
                                decoration: InputDecoration(
                                  labelText: 'Doctor Email'.tr,
                                ),
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _doctorEmailFocusNode,
                              ),
                            ],
                          ),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'description',
                        decoration: InputDecoration(
                          labelText: 'Comment from staff'.tr,
                        ),
                        validator: FormBuilderValidators.compose([]),
                        minLines: 3,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 30),
                      FormBuilderImagePicker(
                        name: 'images',
                        maxImages: 10,
                        decoration: InputDecoration(
                          labelText: 'Attachment'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        cameraLabel: Text('Camera'.tr),
                        galleryLabel: Text('Gallery'.tr),
                      ),
                      const SizedBox(height: 30),
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

                      /// update claim
                      ClaimModel? claim = await ClaimProvider.update(
                        widget.claim.uuid!,
                        data,
                      );

                      /// check if claim is updated
                      if (claim?.uuid != null) {
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

  /// get policies
  Future<void> _getPolicies() async {
    try {
      setState(() => _loadingPolicies = true);
      await DataProvider.policies().then((value) {
        setState(() {
          policies = value;
        });
      });
    } finally {
      setState(() => _loadingPolicies = false);
    }
  }

  /// Get compensation
  Future<void> _getCompensation() async {
    try {
      setState(() => _isLoading = true);

      _formKey.currentState?.save();

      await DataProvider.compensation(
        memberId:
            _formKey.currentState?.value['member_id'] ?? widget.claim.memberId,
        policyId: _formKey.currentState?.value['policy_id'],
        type: _formKey.currentState?.value['type'],
        reasonsOfDeath: _formKey.currentState?.value['reasons_of_death'],
      ).then((value) {
        if (value == null) {
          return;
        }

        compensationKHREditingController.text = "${value['khr']}";
        compensationUSDEditingController.text = "${value['usd']}";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
