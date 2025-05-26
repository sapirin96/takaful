import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takaful/app/data/providers/data_provider.dart';

import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/agency_model.dart';
import '../../../data/providers/agency_provider.dart';
import '../../../services/auth_service.dart';

class CreateAgencyView extends StatefulWidget {
  const CreateAgencyView({super.key});

  @override
  State<CreateAgencyView> createState() => _CreateAgencyViewState();
}

class _CreateAgencyViewState extends State<CreateAgencyView>
    with AutomaticKeepAliveClientMixin<CreateAgencyView> {
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

  List<Map<String, dynamic>> _provinces = [];
  List<Map<String, dynamic>> _districts = [];
  List<Map<String, dynamic>> _communes = [];
  List<Map<String, dynamic>> _villages = [];

  bool _isLoading = false;
  bool _isLoadingProvinces = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingCommunes = false;
  bool _isLoadingVillages = false;
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

  List<Map<String, dynamic>> _staffs = [];
  bool _loadingStaffs = false;

  @override
  void initState() {
    _getProvinces();
    _getStaffs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Consultant'.tr),
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
                      Obx(
                        () => ConditionalBuilder(
                          condition:
                              Get.find<AuthService>().user.value?.roleName ==
                                  'administrator',
                          builder: (_) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FormBuilderDropdown(
                                  name: 'staff_id',
                                  items: _staffs.map((item) {
                                    return DropdownMenuItem(
                                      value: item['value'],
                                      child: Text("${item['title']}"),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Staff'.tr,
                                    helperText:
                                        _loadingStaffs ? 'Loading...'.tr : null,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: 'Staff is required'.tr,
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          fallback: (_) => const SizedBox.shrink(),
                        ),
                      ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'province_id',
                              items: _provinces.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text('${item['name']}'));
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Province'.tr,
                                prefixIcon: _isLoadingProvinces == true
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 30,
                                        height: 30,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : null,
                              ),
                              onChanged: (value) async {
                                int? provinceId = value as int?;
                                _formKey.currentState!.fields['district_id']
                                    ?.didChange(null);
                                _formKey.currentState!.fields['commune_id']
                                    ?.didChange(null);
                                _formKey.currentState!.fields['village_id']
                                    ?.didChange(null);
                                if (provinceId == null) {
                                  return;
                                }
                                await _getDistricts(provinceId);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'district_id',
                              items: _districts.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text('${item['name']}'));
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'District'.tr,
                                prefixIcon: _isLoadingDistricts == true
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 30,
                                        height: 30,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : null,
                              ),
                              onChanged: (value) async {
                                int? districtId = value as int?;
                                _formKey.currentState!.fields['commune_id']
                                    ?.didChange(null);
                                _formKey.currentState!.fields['village_id']
                                    ?.didChange(null);
                                if (districtId == null) {
                                  return;
                                }
                                await _getCommunes(districtId);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'commune_id',
                              items: _communes.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text('${item['name']}'));
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Commune'.tr,
                                prefixIcon: _isLoadingCommunes == true
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 30,
                                        height: 30,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : null,
                              ),
                              onChanged: (value) async {
                                int? communeId = value as int?;
                                _formKey.currentState!.fields['village_id']
                                    ?.didChange(null);
                                if (communeId == null) {
                                  return;
                                }
                                await _getVillages(communeId);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'village_id',
                              items: _villages.map((item) {
                                return DropdownMenuItem(
                                    value: item['id'],
                                    child: Text('${item['name']}'));
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Village'.tr,
                                prefixIcon: _isLoadingVillages == true
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: 30,
                                        height: 30,
                                        child:
                                            const CircularProgressIndicator(),
                                      )
                                    : null,
                              ),
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

                      AgencyModel? agency = await AgencyProvider.store(
                        data,
                      );

                      if (agency?.uuid != null) {
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

  /// Get provinces
  Future<void> _getProvinces() async {
    try {
      setState(() {
        _isLoadingProvinces = true;
      });
      List<Map<String, dynamic>> provinces = await DataProvider.provinces();
      setState(() {
        _provinces = provinces;
      });
    } finally {
      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  /// Get districts
  Future<void> _getDistricts(int? provinceId) async {
    try {
      setState(() {
        _isLoadingDistricts = true;
      });
      List<Map<String, dynamic>> districts =
          await DataProvider.districts(provinceId: provinceId);
      setState(() {
        _districts = districts;
      });
    } finally {
      setState(() {
        _isLoadingDistricts = false;
      });
    }
  }

  /// Get communes
  Future<void> _getCommunes(int? districtId) async {
    try {
      setState(() {
        _isLoadingCommunes = true;
      });
      List<Map<String, dynamic>> communes =
          await DataProvider.communes(districtId: districtId);
      setState(() {
        _communes = communes;
      });
    } finally {
      setState(() {
        _isLoadingCommunes = false;
      });
    }
  }

  /// Get villages
  Future<void> _getVillages(int? communeId) async {
    try {
      setState(() {
        _isLoadingVillages = true;
      });
      List<Map<String, dynamic>> villages =
          await DataProvider.villages(communeId: communeId);
      setState(() {
        _villages = villages;
      });
    } finally {
      setState(() {
        _isLoadingVillages = false;
      });
    }
  }

  /// get staffs data
  Future<void> _getStaffs() async {
    try {
      setState(() {
        _loadingStaffs = true;
      });
      List<Map<String, dynamic>> staffs = await DataProvider.staffs();

      setState(() {
        _staffs = staffs;
      });
    } finally {
      setState(() {
        _loadingStaffs = false;
      });
    }
  }
}
