import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:takaful/app/modules/auth/views/staff_login_view.dart';
import 'package:takaful/packages/loading_overlay.dart';

import '../../../../components/primary_button_component.dart';
import '../../../locales/translation.dart';
import '../../../routes/app_pages.dart';
import '../../../services/setting_service.dart';
import '../controllers/auth_controller.dart';

class AuthRegisterView extends StatefulWidget {
  const AuthRegisterView({super.key});

  @override
  State<AuthRegisterView> createState() => _AuthRegisterViewState();
}

class _AuthRegisterViewState extends State<AuthRegisterView> {
  final AuthController controller = Get.find<AuthController>();
  final SettingService setting = Get.find<SettingService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _nameKhFocusNode = FocusNode();
  final FocusNode _nameEnFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Account'.tr),
        ),
        body: SafeArea(
          child: FormBuilder(
            key: _formKey,
            enabled: true,
            clearValueOnUnregister: true,
            initialValue: const {},
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
                    focusNode: _nameKhFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _nameEnFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _phoneFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _emailFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                  KeyboardActionsItem(
                    focusNode: _passwordFocusNode,
                    displayDoneButton: true,
                    displayArrows: true,
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Register Member Account'.tr,
                      style: Get.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
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
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.account_circle),
                            contentPadding: const EdgeInsets.only(left: 12),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required'.tr),
                          ]),
                          focusNode: _nameKhFocusNode,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'name_en',
                          decoration: InputDecoration(
                            labelText: 'English Name'.tr,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.account_circle),
                            contentPadding: const EdgeInsets.only(left: 12),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'This field is required'.tr),
                          ]),
                          focusNode: _nameEnFocusNode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FormBuilderPhoneField(
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
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
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
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password'.tr,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      contentPadding: const EdgeInsets.only(left: 12),
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
                      FormBuilderValidators.minLength(6),
                    ]),
                    focusNode: _passwordFocusNode,
                  ),
                  const SizedBox(height: 40),
                  PrimaryButtonComponent(
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await controller.registerAsMember(
                          nameKh: _formKey.currentState!.value['name_kh'],
                          nameEn: _formKey.currentState!.value['name_en'],
                          phone: _formKey.currentState!.value['phone'],
                          email: _formKey.currentState!.value['email'],
                          password: _formKey.currentState!.value['password'],
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      } else {
                        Get.rawSnackbar(
                          message: 'Please check all input fields'.tr,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text(
                      'Create Account'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const StaffLoginView());
                    },
                    child: Text('Login as staff or consultant →'.tr),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.MAIN);
                    },
                    icon: const Icon(Icons.home),
                    label: Text('Return Home'.tr),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: Messages.languages.map((language) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Opacity(
                                opacity:
                                    setting.defaultLocale.value == language.code
                                        ? 1
                                        : 0.5,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(language.assetUrl!),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Opacity(
                                opacity:
                                    setting.defaultLocale.value == language.code
                                        ? 1
                                        : 0.5,
                                child: Text(
                                  language.name!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setting.switchLocale(language.code!);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
