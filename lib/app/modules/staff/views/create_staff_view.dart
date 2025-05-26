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
import '../../../data/models/staff_model.dart';
import '../../../data/providers/staff_provider.dart';

class CreateStaffView extends StatefulWidget {
  const CreateStaffView({super.key});

  @override
  State<CreateStaffView> createState() => _CreateStaffViewState();
}

class _CreateStaffViewState extends State<CreateStaffView>
    with AutomaticKeepAliveClientMixin<CreateStaffView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _khmerNameFocusNode = FocusNode();
  final FocusNode _englishNameFocusNode = FocusNode();
  final FocusNode _identityCardFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailAddressFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _placeOfBirthFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _monthlyTargetFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscureText = true;

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
          title: Text('Create Staff'.tr),
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
                      focusNode: _passwordFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _addressFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _monthlyTargetFocusNode,
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
                                    errorText: 'This field is required'.tr),
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
                                    errorText: 'This field is required'.tr),
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
                              errorText: 'This field is required'.tr),
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
                              errorText: 'This field is required'.tr),
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
                              errorText: 'This field is required'.tr),
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
                                    errorText: 'This field is required'.tr),
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
                                    errorText: 'This field is required'.tr),
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
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _phoneNumberFocusNode,
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email Address'.tr,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _emailAddressFocusNode,
                      ),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: InputDecoration(
                          labelText: 'Password'.tr,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _passwordFocusNode,
                        obscureText: _obscureText,
                      ),
                      FormBuilderTextField(
                        name: 'address',
                        decoration: InputDecoration(
                          labelText: 'Address'.tr,
                          prefixIcon: const Icon(Icons.maps_home_work_rounded),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _addressFocusNode,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'joint_date',
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: 'Joint date'.tr,
                                prefixIcon: const Icon(Icons.calendar_month),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              initialValue: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderTextField(
                              name: 'monthly_target',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                labelText: 'Monthly Target'.tr,
                                prefixIcon: const Icon(Icons.power_input),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'This field is required'.tr),
                              ]),
                              focusNode: _monthlyTargetFocusNode,
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

                      if (_formKey.currentState!.value['images'] != null) {
                        image = await MultipartFile.fromFile(
                          _formKey
                              .currentState!.fields['images']!.value[0].path,
                          filename: 'image.jpg',
                        );
                      }

                      FormData data = FormData.fromMap({
                        'profile_picture': image,
                        ..._formKey.currentState!.value,
                      });

                      StaffModel? staff = await StaffProvider.store(
                        data,
                      );

                      if (staff?.uuid != null) {
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
