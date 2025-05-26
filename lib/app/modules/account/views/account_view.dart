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
import 'package:takaful/app/modules/account/controllers/account_controller.dart';
import 'package:takaful/app/services/auth_service.dart';
import 'package:takaful/components/primary_button_component.dart';
import 'package:takaful/packages/loading_overlay.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final AuthService auth = Get.find<AuthService>();
  final AccountController controller = Get.find<AccountController>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account'.tr),
          centerTitle: false,
        ),
        body: SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: KeyboardActions(
              config: KeyboardActionsConfig(
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
                    focusNode: _emailFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _phoneFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Obx(
                          () => FormBuilderImagePicker(
                            name: 'images',
                            maxImages: 1,
                            decoration: InputDecoration(
                              labelText: 'Profile Photo'.tr,
                              border: InputBorder.none,
                            ),
                            fit: BoxFit.cover,
                            cameraLabel: Text('Camera'.tr),
                            galleryLabel: Text('Gallery'.tr),
                            placeholderImage: auth.user.value?.imageUrl != null
                                ? NetworkImage(auth.user.value!.imageUrl!)
                                : null,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Obx(() => FormBuilderTextField(
                        initialValue: auth.user.value?.name,
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: 'Name'.tr,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.account_circle),
                          contentPadding: const EdgeInsets.only(left: 12),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _nameFocusNode,
                      )),
                  const SizedBox(height: 20),
                  Obx(() => FormBuilderPhoneField(
                        initialValue: auth.user.value?.phone,
                        name: 'phone',
                        decoration: InputDecoration(
                          labelText: 'Phone Number'.tr,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.only(left: 12),
                        ),
                        isCupertinoPicker: false,
                        countryFilterByIsoCode: const ['KH'],
                        priorityListByIsoCode: const ['KH'],
                        defaultSelectedCountryIsoCode: 'KH',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'.tr),
                        ]),
                        focusNode: _phoneFocusNode,
                      )),
                  const SizedBox(height: 20),
                  Obx(
                    () => FormBuilderTextField(
                      initialValue: auth.user.value?.email,
                      name: 'email',
                      decoration: InputDecoration(
                        labelText: 'Email'.tr,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                        contentPadding: const EdgeInsets.only(left: 12),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'This field is required'.tr),
                        FormBuilderValidators.email(),
                      ]),
                      focusNode: _emailFocusNode,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: PrimaryButtonComponent(
              onPressed: () async {
                try {
                  if (_formKey.currentState!.saveAndValidate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    /// transform image to MultipartFile
                    MultipartFile? image;
                    if (_formKey.currentState!.value['images'] != null) {
                      image = await MultipartFile.fromFile(
                        _formKey.currentState!.fields['images']!.value[0].path,
                        filename: _formKey
                            .currentState!.fields['images']!.value[0].path
                            .split('/')
                            .last,
                      );
                    }

                    /// transform form data to FormData
                    FormData data = FormData.fromMap({
                      'profile_picture': image,
                      ..._formKey.currentState!.value,
                    });

                    /// update user
                    switch (auth.user.value!.tokenableType) {
                      case 'user':
                        await controller.updateUser(data);
                        break;
                      case 'staff':
                        await controller.updateStaff(data);
                        break;
                      case 'agency':
                        await controller.updateAgency(data);
                        break;
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
    );
  }
}
