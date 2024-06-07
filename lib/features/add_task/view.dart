import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/helpers/navigator.dart';
import 'package:tasky_app/core/networking/urls_strings.dart';
import 'package:tasky_app/core/theming/assets.dart';
import 'package:tasky_app/core/theming/colors.dart';
import 'package:tasky_app/core/widgets/custom_elevated.dart';
import 'package:tasky_app/core/widgets/custom_text.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/core/widgets/emit_failed_item.dart';
import 'package:tasky_app/core/widgets/emit_loading_item.dart';
import 'package:tasky_app/core/widgets/emit_network_item.dart';
import 'package:tasky_app/core/widgets/snack_bar.dart';
import 'package:tasky_app/core/widgets/svg_icons.dart';
import 'package:tasky_app/features/details/widgets/custom_container.dart';
import 'package:tasky_app/features/home/view.dart';
import 'package:tasky_app/features/register/components/choose_experience_level.dart';

import 'cubit.dart';
import 'states.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({
    super.key,
    required this.fromEdit,
    this.id = "",
    this.user = "",
    this.editImageTextUploaded = "",
    this.editTitle = "",
    this.editDesc = "",
    this.editPriority = "",
    this.status = "",
  });

  final bool fromEdit;
  final String id, user;
  final String editImageTextUploaded, editTitle, editDesc, editPriority, status;

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (context) => AddTaskCubit(),
    //   child: const _AddTaskBody(),
    // );
    return _AddTaskBody(
      fromEdit: fromEdit,
      id: id,
      user: user,
      editImageTextUploaded: editImageTextUploaded,
      editTitle: editTitle,
      editDesc: editDesc,
      editPriority: editPriority,
      status: status,
    );
  }
}

class _AddTaskBody extends StatelessWidget {
  const _AddTaskBody({
    required this.fromEdit,
    required this.id,
    required this.user,
    required this.editImageTextUploaded,
    required this.editTitle,
    required this.editDesc,
    required this.editPriority,
    required this.status,
  });

  final bool fromEdit;
  final String id, user;
  final String editImageTextUploaded, editTitle, editDesc, editPriority, status;

  @override
  Widget build(BuildContext context) {
    final cubit = AddTaskCubit.get(context);

    fromEdit ? cubit.imageTextUploaded = editImageTextUploaded : null;
    fromEdit ? cubit.controllers.titleController.text = editTitle : null;
    fromEdit ? cubit.controllers.descController.text = editDesc : null;
    fromEdit ? cubit.priority = editPriority : null;
    cubit.status = "";

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgIcon(
            icon: AssetsStrings.arrowLeft,
            color: ColorManager.black,
            height: 25.h,
          ),
        ),
        title: CustomText(
          text: "Add new task",
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Form(
        key: cubit.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              BlocConsumer<AddTaskCubit, AddTaskStates>(
                listener: (context, state) {
                  if (state is UploadProductImageStates) {
                    cubit.addImage();
                  }
                },
                builder: (context, state) {
                  if (state is AddImageLoadingState) {
                    return Padding(
                      padding: EdgeInsets.all(5.h),
                      child: const EmitLoadingItem(),
                    );
                  } else if (state is AddImageNetworkErrorState) {
                    return const EmitNetworkItem();
                  } else if (state is AddImageFailedState) {
                    return EmitFailedItem(text: state.msg);
                  }

                  return fromEdit
                      ? GestureDetector(
                          onTap: () {
                            cubit.chooseProductImage();
                          },
                          child: Image.network(
                            "${UrlsStrings.baseImagesUrl}$editImageTextUploaded",
                            height: 0.3.sh,
                            fit: BoxFit.scaleDown,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            cubit.chooseProductImage();
                          },
                          child: cubit.imageTextUploaded.isNotEmpty
                              ? Image.network(
                                  "${UrlsStrings.baseImagesUrl}${cubit.imageTextUploaded}",
                                  height: 0.3.sh,
                                  fit: BoxFit.scaleDown,
                                )
                              : Image.asset(
                                  AssetsStrings.addImage,
                                ),
                        );
                },
              ),
              SizedBox(height: 0.03.sh),
              _TitleTextField(cubit: cubit),
              SizedBox(height: 0.02.sh),
              _DescTextField(cubit: cubit),
              SizedBox(height: 0.02.sh),
              _PriorityField(cubit: cubit),
              fromEdit
                  ? Column(
                      children: [
                        SizedBox(height: 0.02.sh),
                        _StatusField(
                          cubit: cubit,
                          status: status,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              fromEdit
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.only(top: 0.02.sh),
                      child: _DateField(cubit: cubit),
                    ),
              SizedBox(height: 0.029.sh),
              fromEdit
                  ? _EditTaskButton(
                      cubit: cubit,
                      id: id,
                      user: user,
                    )
                  : _AddTaskButton(cubit: cubit),
              SizedBox(height: 0.2.sh),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({required this.cubit});

  final AddTaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Task title",
              color: ColorManager.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: cubit.controllers.titleController,
              hint: "Enter title here...",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter title";
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}

class _DescTextField extends StatelessWidget {
  const _DescTextField({required this.cubit});

  final AddTaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Task Description",
              color: ColorManager.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 180.h,
              child: CustomTextFormFieldExpends(
                controller: cubit.controllers.descController,
                hint: "Enter description here...",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter description";
                  }
                  return null;
                },
                maxLines: null,
                expands: true,
                action: TextInputAction.done,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PriorityField extends StatelessWidget {
  const _PriorityField({required this.cubit});

  final AddTaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Priority",
              color: ColorManager.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              child: CustomContainer(
                withIcon: true,
                text: cubit.priority != "" ? cubit.priority : "Choose Priority",
              ),
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: ColorManager.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.r),
                      topLeft: Radius.circular(15.r),
                    ),
                  ),
                  builder: (context) {
                    return BlocBuilder<AddTaskCubit, AddTaskStates>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.all(0.041.sw),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cubit.priorityName.length,
                            itemBuilder: (context, index) {
                              return ItemContainerWidget(
                                onTap: () {
                                  cubit.updateExperienceLevel(
                                    priorityP: cubit.priorityName[index],
                                  );
                                  MagicRouter.navigatePop();
                                },
                                title: cubit.priorityName[index],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _StatusField extends StatelessWidget {
  const _StatusField({required this.cubit, required this.status});

  final AddTaskCubit cubit;
  final String status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Status",
              color: ColorManager.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              child: CustomContainer(
                withIcon: true,
                text: cubit.status.isNotEmpty ? cubit.status : status,
              ),
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: ColorManager.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.r),
                      topLeft: Radius.circular(15.r),
                    ),
                  ),
                  builder: (context) {
                    return BlocBuilder<AddTaskCubit, AddTaskStates>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.all(0.041.sw),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cubit.statusName.length,
                            itemBuilder: (context, index) {
                              return ItemContainerWidget(
                                onTap: () {
                                  cubit.updateStatus(
                                    statusS: cubit.statusName[index],
                                  );
                                  MagicRouter.navigatePop();
                                },
                                title: cubit.statusName[index],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.cubit});

  final AddTaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Due date",
          color: ColorManager.grey,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AddTaskCubit, AddTaskStates>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                cubit.pressDate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 15.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: ColorManager.secColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: cubit.dateTime != null
                                ? cubit.dateTime!.toString().split(" ").first
                                : "choose due date...",
                            color: ColorManager.mainColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      AssetsStrings.calendar,
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton({required this.cubit});

  final AddTaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) {
        if (state is AddTaskFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.redPrimary,
          );
        } else if (state is AddTaskNetworkErrorState) {
          showMessage(
            message: "No Internet connection",
            color: ColorManager.redPrimary,
          );
        } else if (state is AddTaskSuccessState) {
          MagicRouter.navigateTo(
            page: const HomeView(),
            withHistory: false,
          );

          cubit.productImage = null;
          cubit.dateTime = null;
          cubit.imageTextUploaded = "";
          cubit.priority = "";
          cubit.controllers.titleController.clear();
          cubit.controllers.descController.clear();
        }
      },
      builder: (context, state) {
        if (state is AddTaskLoadingState) {
          return const EmitLoadingItem();
        }
        return CustomElevated(
          text: 'Add task',
          press: () {
            if (cubit.imageTextUploaded.isEmpty) {
              showMessage(
                message: "Upload Image First",
                color: ColorManager.redPrimary,
              );
            } else if (cubit.priority.isEmpty) {
              showMessage(
                message: "choose priority",
                color: ColorManager.redPrimary,
              );
            } else if (cubit.dateTime == null) {
              showMessage(
                message: "choose due date",
                color: ColorManager.redPrimary,
              );
            } else {
              cubit.addTask();
            }
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}

class _EditTaskButton extends StatelessWidget {
  const _EditTaskButton({
    required this.cubit,
    required this.id,
    required this.user,
  });

  final AddTaskCubit cubit;
  final String id, user;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) {
        if (state is EditTaskFailedState) {
          showMessage(
            message: state.msg,
            color: ColorManager.redPrimary,
          );
        } else if (state is EditTaskNetworkErrorState) {
          showMessage(
            message: "No Internet connection",
            color: ColorManager.redPrimary,
          );
        } else if (state is EditTaskSuccessState) {
          MagicRouter.navigateTo(
            page: const HomeView(),
            withHistory: false,
          );

          cubit.productImage = null;
          cubit.dateTime = null;
          cubit.imageTextUploaded = "";
          cubit.priority = "";
          cubit.controllers.titleController.clear();
          cubit.controllers.descController.clear();
        }
      },
      builder: (context, state) {
        if (state is EditTaskLoadingState) {
          return const EmitLoadingItem();
        }
        return CustomElevated(
          text: 'Add task',
          press: () {
            if (cubit.imageTextUploaded.isEmpty) {
              showMessage(
                message: "Upload Image First",
                color: ColorManager.redPrimary,
              );
            } else if (cubit.priority.isEmpty) {
              showMessage(
                message: "choose priority",
                color: ColorManager.redPrimary,
              );
            } else {
              cubit.editTask(id: id, user: user);
            }
          },
          btnColor: ColorManager.mainColor,
        );
      },
    );
  }
}
