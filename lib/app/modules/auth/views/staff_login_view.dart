import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../components/primary_button_component.dart';
import '../../../../packages/loading_overlay.dart';
import '../../../locales/translation.dart';
import '../../../services/setting_service.dart';
import '../controllers/auth_controller.dart';

class StaffLoginView extends StatefulWidget {
  const StaffLoginView({super.key});

  @override
  State<StaffLoginView> createState() => _StaffLoginViewState();
}

class _StaffLoginViewState extends State<StaffLoginView> {
  final AuthController controller = Get.find<AuthController>();
  final SettingService setting = Get.find<SettingService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscureText = true;
  bool _isLoading = false;
  String? role = 'staff';

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData.fallback(),
          actionsIconTheme: const IconThemeData.fallback(),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
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
                      const Center(
                        child: Image(
                          image: AssetImage('lib/assets/images/logo.png'),
                          width: 170,
                          height: 170,
                        ),
                      ),
                      Text(
                        'Welcome'.tr,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Please login to continue'.tr,
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Login as'.tr,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: 'staff',
                                  groupValue: role,
                                  toggleable: false,
                                  onChanged: (value) {
                                    setState(() {
                                      role = value;
                                    });
                                  },
                                ),
                                Text('Staff'.tr),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: 'agency',
                                  groupValue: role,
                                  toggleable: false,
                                  onChanged: (value) {
                                    setState(() {
                                      role = value;
                                    });
                                  },
                                ),
                                Text('Consultant'.tr),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: 'user',
                                  groupValue: role,
                                  toggleable: false,
                                  onChanged: (value) {
                                    setState(() {
                                      role = value;
                                    });
                                  },
                                ),
                                Text('Admin'.tr),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email'.tr,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email),
                          helperText:
                              "Enter your email provided by your company".tr,
                          helperMaxLines: 1,
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
                          helperText:
                              "If you forget your password, contact your company"
                                  .tr,
                          helperMaxLines: 1,
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

                            /// Login as a staff
                            if (role == 'staff') {
                              await controller.loginAsStaff(
                                email: _formKey.currentState!.value['email'],
                                password:
                                    _formKey.currentState!.value['password'],
                              );
                            }

                            /// Login as an agency
                            if (role == 'agency') {
                              await controller.loginAsAgency(
                                email: _formKey.currentState!.value['email'],
                                password:
                                    _formKey.currentState!.value['password'],
                              );
                            }

                            if (role == 'user') {
                              await controller.loginAsUser(
                                email: _formKey.currentState!.value['email'],
                                password:
                                    _formKey.currentState!.value['password'],
                              );
                            }

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
                          'Login'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
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
                                    opacity: setting.defaultLocale.value ==
                                            language.code
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
                                    opacity: setting.defaultLocale.value ==
                                            language.code
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
        ),
      ),
    );
  }
}
