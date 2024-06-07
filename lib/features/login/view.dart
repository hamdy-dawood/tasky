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
import 'package:tasky_app/core/widgets/phone_number_input.dart';
import 'package:tasky_app/core/widgets/snack_bar.dart';
import 'package:tasky_app/features/home/view.dart';

import 'components/register_line.dart';
import 'cubit.dart';
import 'states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  _LoginBody();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          children: [
            Image.asset(
              AssetsStrings.authImage,
              height: 0.5.sh,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "login",
                    color: ColorManager.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 0.03.sh),
                  PhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      cubit.onInputChanged(number);
                    },
                  ),
                  SizedBox(height: 0.02.sh),
                  BlocBuilder<LoginCubit, LoginStates>(
                    builder: (context, state) {
                      return _PasswordTextField(cubit: cubit);
                    },
                  ),
                  SizedBox(height: 0.02.sh),
                  _LoginButton(cubit: cubit, formKey: formKey),
                  SizedBox(height: 0.03.sh),
                  const Center(child: RegisterLineWidget()),
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

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});
  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.passwordController,
      keyboardType: TextInputType.text,
      hint: "Password...",
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Password";
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
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.cubit, required this.formKey});
  final LoginCubit cubit;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.redPrimary,
          );
        } else if (state is NetworkErrorState) {
          showMessage(
            message: "check network",
            color: ColorManager.redPrimary,
          );
        } else if (state is LoginSuccessState) {
          return MagicRouter.navigateTo(
            page: const HomeView(),
            withHistory: false,
          );
        }
      },
      builder: (context, state) {
        if (state is LoginLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: "login",
          press: () {
            if (cubit.number.isNotEmpty && formKey.currentState!.validate()) {
              cubit.login();
            }
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
