import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_elevated.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/phone_number_input.dart';
import 'package:tasky_app/core/widgets/snack_bar.dart';
import 'package:tasky_app/features/home/view.dart';

import 'components/choose_experience_level.dart';
import 'components/login_line.dart';
import 'cubit.dart';
import 'states.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterBody();
  }
}

class _RegisterBody extends StatelessWidget {
  const _RegisterBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserRegisterCubit>(context);

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Form(
        key: cubit.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          children: [
            Image.asset(
              AssetsStrings.registerImage,
              height: 0.4.sh,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Register",
                    color: ColorManager.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 0.02.sh),
                  _NameTextField(cubit: cubit),
                  SizedBox(height: 0.02.sh),
                  PhoneNumberInput(
                    onInputChanged: (PhoneNumber phone) {
                      cubit.onInputChanged(phone);
                    },
                  ),
                  SizedBox(height: 0.014.sh),
                  _YearExperienceTextField(cubit: cubit),
                  SizedBox(height: 0.02.sh),
                  BlocBuilder<UserRegisterCubit, UserRegisterStates>(
                    builder: (context, state) {
                      return ChooseExperienceLevel(cubit: cubit);
                    },
                  ),
                  SizedBox(height: 0.02.sh),
                  _AddressTextField(cubit: cubit),
                  SizedBox(height: 0.02.sh),
                  _PasswordTextField(cubit: cubit),
                  SizedBox(height: 0.029.sh),
                  BlocConsumer<UserRegisterCubit, UserRegisterStates>(
                    listener: (context, state) {
                      if (state is UserRegisterFailedState) {
                        showMessage(
                          message: state.msg,
                          color: ColorManager.redPrimary,
                        );
                      } else if (state is UserNetworkErrorState) {
                        showMessage(
                          message: "No Internet connection",
                          color: ColorManager.redPrimary,
                        );
                      } else if (state is UserRegisterSuccessState) {
                        return MagicRouter.navigateTo(
                          page: const HomeView(),
                          withHistory: false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is UserRegisterLoadingState) {
                        return const EmitLoadingItem();
                      }
                      return CustomElevated(
                        text: 'register',
                        press: () {
                          cubit.userRegister();
                        },
                        btnColor: ColorManager.mainColor,
                      );
                    },
                  ),
                  SizedBox(height: 0.027.sh),
                  const Center(child: LoginLineWidget()),
                  SizedBox(height: 0.02.sh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({required this.cubit});

  final UserRegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: cubit.controllers.nameController,
          hint: "Name...",
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter Name";
            }
            return null;
          },
        );
      },
    );
  }
}

class _YearExperienceTextField extends StatelessWidget {
  const _YearExperienceTextField({required this.cubit});

  final UserRegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: cubit.controllers.experienceController,
          hint: "Years of experience...",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Years of experience";
            }
            return null;
          },
        );
      },
    );
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({required this.cubit});

  final UserRegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: cubit.controllers.addressController,
          hint: "Address...",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Address";
            }
            return null;
          },
        );
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});

  final UserRegisterCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRegisterCubit, UserRegisterStates>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: cubit.controllers.passwordController,
          hint: "password",
          validator: (value) {
            if (value.isEmpty) {
              return "enter_password";
            } else if (value.length < 6) {
              return "enter_6_password";
            }
            return null;
          },
          suffixIcon: SizedBox(
            height: 0.02.sh,
            child: GestureDetector(
              onTap: () {
                cubit.changeVisibility();
              },
              child: Icon(
                cubit.isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: ColorManager.grey3,
              ),
            ),
          ),
          obscureText: cubit.isObscure,
          interactiveSelection: false,
          isLastInput: true,
        );
      },
    );
  }
}
