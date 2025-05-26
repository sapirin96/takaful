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

import '../../../../components/primary_button_component.dart';
import '../../../../configs/app_config.dart';
import '../../../../packages/conditional_builder.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../data/models/member_model.dart';
import '../../../data/providers/data_provider.dart';
import '../../../data/providers/member_provider.dart';
import '../../../services/auth_service.dart';

class EditMemberView extends StatefulWidget {
  final MemberModel member;

  const EditMemberView({super.key, required this.member});

  @override
  State<EditMemberView> createState() => _EditMemberViewState();
}

class _EditMemberViewState extends State<EditMemberView>
    with AutomaticKeepAliveClientMixin<EditMemberView> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _khmerNameFocusNode = FocusNode();
  final FocusNode _englishNameFocusNode = FocusNode();
  final FocusNode _identityCardFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailAddressFocusNode = FocusNode();
  final FocusNode _placeOfBirthFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _occupationFocusNode = FocusNode();
  final FocusNode _maritalStatusFocusNode = FocusNode();
  final FocusNode _emergencyContactFocusNode = FocusNode();
  final FocusNode _emergencyPhoneFocusNode = FocusNode();
  final FocusNode _illnessFocusNode = FocusNode();
  final FocusNode _disabilityFocusNode = FocusNode();

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

  List<Map<String, dynamic>> _staffs = [];
  List<Map<String, dynamic>> _agencies = [];
  bool _loadingStaffs = false;
  bool _loadingAgencies = false;

  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    _getStaffs();
    if (widget.member.staffId != null) {
      _getAgencies(staffId: widget.member.staffId!);
    }

    _initialValue = widget.member.toJson();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Member'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: FormBuilder(
              key: _formKey,
              initialValue: _initialValue,
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
                    KeyboardActionsItem(
                      focusNode: _occupationFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _maritalStatusFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _emergencyContactFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _emergencyPhoneFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _illnessFocusNode,
                      displayDoneButton: true,
                      displayArrows: true,
                    ),
                    KeyboardActionsItem(
                      focusNode: _disabilityFocusNode,
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
                                  /// check if widget.member.staff_id is existed in _staffs list for set initial value
                                  // initialValue: _staffs.firstWhereOrNull((element) => element['value'] == widget.member.staffId) != null ? widget.member.staffId : null,
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
                                  onChanged: (value) async {
                                    _formKey.currentState!.fields['agency_id']
                                        ?.didChange(null);
                                    await _getAgencies(
                                        staffId:
                                            int.tryParse(value.toString()));
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FormBuilderDropdown(
                                  /// check if widget.member.agency_id is existed in _agencies list for set initial value
                                  // initialValue: _agencies.firstWhereOrNull((element) => element['value'] == widget.member.agencyId) != null ? widget.member.agencyId : null,
                                  name: 'agency_id',
                                  items: _agencies.map((item) {
                                    return DropdownMenuItem(
                                      value: item['value'],
                                      child: Text("${item['title']}"),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    labelText: 'Consultant'.tr,
                                    helperText: _loadingAgencies
                                        ? 'Loading...'.tr
                                        : null,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(
                                      errorText: 'Consultant is required'.tr,
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
                        placeholderImage:
                            widget.member.profilePictureUrl != null
                                ? NetworkImage(widget.member.profilePictureUrl!)
                                : null,
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
                                    errorText: 'Khmer Name is required'.tr),
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
                                    errorText: 'English Name is required'.tr),
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
                              errorText: 'Identity Card is required'.tr),
                        ]),
                        focusNode: _identityCardFocusNode,
                      ),
                      FormBuilderDateTimePicker(
                        initialValue: widget.member.dateOfBirth != null
                            ? DateTime.parse(widget.member.dateOfBirth!)
                            : null,
                        name: 'date_of_birth',
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: 'Date of birth'.tr,
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Date of birth is required'.tr),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'place_of_birth',
                        decoration: InputDecoration(
                          labelText: 'Place of birth'.tr,
                          prefixIcon: const Icon(Icons.maps_home_work_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Place of birth is required'.tr),
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
                                    errorText: 'Gender is required'.tr),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('Occupation'.tr),
                              subtitle: FormBuilderTextField(
                                name: 'occupation',
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _occupationFocusNode,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('Marital Status'.tr),
                              subtitle: FormBuilderTextField(
                                name: 'marital_status',
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _maritalStatusFocusNode,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('Emergency Contact'.tr),
                              subtitle: FormBuilderTextField(
                                name: 'emergency_contact',
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _emergencyContactFocusNode,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text('Emergency Phone'.tr),
                              subtitle: FormBuilderTextField(
                                name: 'emergency_phone',
                                validator: FormBuilderValidators.compose([]),
                                focusNode: _emergencyPhoneFocusNode,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'តើអ្នកធ្លាប់មាន ឬកំពុងមានជំងឺប្រចាំកាយដែរឬទេ? បើមាន, តើអ្នកមានជំងឺអ្វី? *'),
                            FormBuilderTextField(
                              name: 'illness',
                              validator: FormBuilderValidators.compose([]),
                              focusNode: _illnessFocusNode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'តើអ្នកធ្លាប់មាន ឬកំពុងមានពិការភាពដែរឬទេ? បើមាន, តើអ្នកមានពិការភាពលើអ្វី? *'),
                            FormBuilderTextField(
                              name: 'disability',
                              validator: FormBuilderValidators.compose([]),
                              focusNode: _disabilityFocusNode,
                            ),
                          ],
                        ),
                      ),
                      FormBuilderDateTimePicker(
                        initialValue: widget.member.jointDate != null
                            ? DateTime.parse(widget.member.jointDate!)
                            : null,
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
                        enabled: false,
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
                              placeholderImage:
                                  widget.member.frontDocumentUrl != null
                                      ? NetworkImage(
                                          widget.member.frontDocumentUrl!)
                                      : null,
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
                              placeholderImage: widget.member.backDocumentUrl !=
                                      null
                                  ? NetworkImage(widget.member.backDocumentUrl!)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Note'.tr,
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                'សមាគមអាម៉ាណះតាកាហ្វុលកម្ពុជា សូមធ្វើការរក្សាទុកនូវទិន្នន័យសមាជិកខាងលើ ដើម្បីផ្ទៀងផ្ទាត់ស្ថានភាពព័ត៌មានឬឯកសារសមាជិកជាក់ស្តែង និងធានាអោយបានថាមិនមានការក្លែងបន្លំព័ត៌មានឬឯកសារសមាជិក នៅក្នុងចេតនាអវិជ្ជមាន និងបាត់ប្រយោជន៍ដល់សមាជិកដ៏ទៃ។'),
                          ],
                        ),
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
                        '_method': 'PUT',
                        ..._formKey.currentState!.value,
                      });

                      MemberModel? member = await MemberProvider.update(
                        widget.member.uuid!,
                        data,
                      );

                      if (member?.uuid != null) {
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

  /// get staffs data
  Future<void> _getStaffs() async {
    try {
      setState(() {
        _loadingStaffs = true;
      });
      await Future.delayed(const Duration(seconds: 5));

      List<Map<String, dynamic>> staffs = await DataProvider.staffs();

      setState(() {
        _staffs = staffs;
      });

      if (_staffs.firstWhereOrNull(
              (element) => element['value'] == widget.member.staffId) ==
          null) {
        _formKey.currentState!.fields['staff_id']!.didChange(null);
      }
    } finally {
      setState(() {
        _loadingStaffs = false;
      });
    }
  }

  /// get agencies data
  Future<void> _getAgencies({int? staffId}) async {
    try {
      setState(() {
        _loadingAgencies = true;
      });

      await Future.delayed(const Duration(seconds: 5));

      List<Map<String, dynamic>> agencies =
          await DataProvider.agencies(staffId: staffId);
      setState(() {
        _agencies = agencies;
      });

      if (_agencies.firstWhereOrNull(
              (element) => element['value'] == widget.member.agencyId) ==
          null) {
        _formKey.currentState!.fields['agency_id']!.didChange(null);
      }
    } finally {
      setState(() {
        _loadingAgencies = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
