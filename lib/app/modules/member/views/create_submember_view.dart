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
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/member_model.dart';
import '../../../data/models/submember_model.dart';
import '../../../data/providers/submember_provider.dart';

class CreateSubmemberView extends StatefulWidget {
  final MemberModel member;

  const CreateSubmemberView({super.key, required this.member});

  @override
  State<CreateSubmemberView> createState() => _CreateSubmemberViewState();
}

class _CreateSubmemberViewState extends State<CreateSubmemberView>
    with AutomaticKeepAliveClientMixin<CreateSubmemberView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _khmerNameFocusNode = FocusNode();
  final FocusNode _englishNameFocusNode = FocusNode();
  final FocusNode _identityCardFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailAddressFocusNode = FocusNode();
  final FocusNode _placeOfBirthFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  bool _isLoading = false;
  final List<Map<String, dynamic>> religions = [
    {
      'value': 'muslim',
      'label': 'Muslim'.tr,
    },
    {
      'value': 'non_muslim',
      'label': 'Non Muslim'.tr,
    },
  ];

  final List<Map<String, dynamic>> genders = [
    {
      'value': 'male',
      'label': 'Male'.tr,
    },
    {
      'value': 'female',
      'label': 'Female'.tr,
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Submember'.tr),
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
                      focusNode: _khmerNameFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _englishNameFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _identityCardFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _placeOfBirthFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _phoneNumberFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _emailAddressFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _addressFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      FormBuilderImagePicker(
                        name: 'images',
                        maxImages: 1,
                        decoration: InputDecoration(
                          labelText: 'Profile Photo'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        cameraLabel: Text('Camera'.tr),
                        galleryLabel: Text('Gallery'.tr),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'name_kh',
                              decoration: InputDecoration(
                                labelText: 'Khmer Name'.tr,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Khmer Name is required'.tr,
                                ),
                              ]),
                              focusNode: _khmerNameFocusNode,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'name_en',
                              decoration: InputDecoration(
                                labelText: 'English Name'.tr,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'English Name is required'.tr,
                                ),
                              ]),
                              focusNode: _englishNameFocusNode,
                            ),
                          ),
                        ],
                      ),
                      FormBuilderTextField(
                        name: 'identity_number',
                        decoration: InputDecoration(
                          labelText: 'Identity Card'.tr,
                          prefixIcon: const Icon(Icons.credit_card_sharp),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Identity Card is required'.tr,
                          ),
                        ]),
                        focusNode: _identityCardFocusNode,
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date_of_birth',
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: 'Date of birth'.tr,
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Date of birth is required'.tr,
                          ),
                        ]),
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'place_of_birth',
                        decoration: InputDecoration(
                          labelText: 'Place of birth'.tr,
                          prefixIcon: const Icon(Icons.maps_home_work_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: 'Place of birth is required'.tr,
                          ),
                        ]),
                        focusNode: _placeOfBirthFocusNode,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'gender',
                              items: genders.map((gender) {
                                return DropdownMenuItem(
                                  value: gender['value'],
                                  child: Text("${gender['label']}"),
                                );
                              }).toList(),
                              decoration: const InputDecoration().copyWith(
                                label: Text('Gender'.tr),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: "Gender is required".tr),
                              ]),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'religion',
                              items: religions.map((religion) {
                                return DropdownMenuItem(
                                  value: religion['value'],
                                  child: Text("${religion['label']}"),
                                );
                              }).toList(),
                              decoration: const InputDecoration().copyWith(
                                label: Text('Nationality'.tr),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Nationality is required'.tr),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      FormBuilderPhoneField(
                        name: 'phone',
                        decoration: InputDecoration(
                          labelText: 'Phone Number'.tr,
                        ),
                        isCupertinoPicker: false,
                        countryFilterByIsoCode: const ['KH'],
                        priorityListByIsoCode: const ['KH'],
                        defaultSelectedCountryIsoCode: 'KH',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Phone Number is required'.tr),
                        ]),
                        focusNode: _phoneNumberFocusNode,
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email Address'.tr,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: FormBuilderValidators.compose([]),
                        focusNode: _emailAddressFocusNode,
                      ),
                      FormBuilderTextField(
                        name: 'address',
                        decoration: InputDecoration(
                          labelText: 'Address'.tr,
                          prefixIcon: const Icon(Icons.maps_home_work_rounded),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Address is required'.tr),
                        ]),
                        focusNode: _addressFocusNode,
                      ),
                      FormBuilderDateTimePicker(
                        name: 'joint_date',
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: 'Joint date'.tr,
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Joint date is required'.tr),
                        ]),
                        initialValue: DateTime.now(),
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderImagePicker(
                              name: 'fronts',
                              maxImages: 1,
                              decoration: InputDecoration(
                                labelText: 'Front Document'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              cameraLabel: Text('Camera'.tr),
                              galleryLabel: Text('Gallery'.tr),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderImagePicker(
                              name: 'backs',
                              maxImages: 1,
                              decoration: InputDecoration(
                                labelText: 'Back Document'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              cameraLabel: Text('Camera'.tr),
                              galleryLabel: Text('Gallery'.tr),
                            ),
                          ),
                        ],
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
                      MultipartFile? image;
                      MultipartFile? backDocument;
                      MultipartFile? frontDocument;

                      if (_formKey.currentState!.value['images'] != null) {
                        image = await MultipartFile.fromFile(
                          _formKey
                              .currentState!.fields['images']!.value[0].path,
                          filename: _formKey
                              .currentState!.fields['images']!.value[0].path
                              .split('/')
                              .last,
                        );
                      }

                      if (_formKey.currentState!.value['backs'] != null) {
                        backDocument = await MultipartFile.fromFile(
                          _formKey.currentState!.fields['backs']!.value[0].path,
                          filename: _formKey
                              .currentState!.fields['backs']!.value[0].path
                              .split('/')
                              .last,
                        );
                      }

                      if (_formKey.currentState!.value['fronts'] != null) {
                        frontDocument = await MultipartFile.fromFile(
                          _formKey
                              .currentState!.fields['fronts']!.value[0].path,
                          filename: _formKey
                              .currentState!.fields['fronts']!.value[0].path
                              .split('/')
                              .last,
                        );
                      }

                      FormData data = FormData.fromMap({
                        'profile_picture': image,
                        'front_document': frontDocument,
                        'back_document': backDocument,
                        'parent_id': widget.member.id,
                        ..._formKey.currentState!.value,
                      });

                      SubmemberModel? member = await SubmemberProvider.store(
                        data,
                      );

                      if (member?.uuid != null) {
                        Get.back(result: true);
                      }
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Text('Save'.tr),
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
