import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import '../../../core/controller/im_controller.dart';
import 'my_info_logic.dart';

class MyInfoPage extends StatelessWidget {
  final logic = Get.find<MyInfoLogic>();
  final imLogic = Get.find<IMController>();

  MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.myInfo,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildItemGroupView(
                  children: [
                    _buildItemView(
                      label: StrRes.avatar,
                      isAvatar: true,
                      value: imLogic.userInfo.value.nickname,
                      url: imLogic.userInfo.value.faceURL,
                      onTap: logic.openPhotoSheet,
                    ),
                    _buildItemView(
                      label: StrRes.name,
                      value: imLogic.userInfo.value.nickname,
                      onTap: logic.editMyName,
                    ),
                    _buildItemView(
                      label: StrRes.gender,
                      value: imLogic.userInfo.value.isMale ? StrRes.man : StrRes.woman,
                      onTap: logic.selectGender,
                    ),
                    _buildItemView(
                      label: StrRes.birthDay,
                      value: (imLogic.userInfo.value.birth != null && imLogic.userInfo.value.birth! > 0) ? DateUtil.formatDateMs(
                        imLogic.userInfo.value.birth ?? 0,
                        format: IMUtils.getTimeFormat1(),
                      ) : "",
                      onTap: logic.openDatePicker,
                    ),
                  ],
                ),
                10.verticalSpace,
                _buildItemGroupView(
                  children: [
                    _buildItemView(
                      label: StrRes.mobile,
                      value: imLogic.userInfo.value.phoneNumber,
                      showRightArrow: false,
                    ),
                    _buildItemView(
                      label: StrRes.email,
                      value: imLogic.userInfo.value.email,
                      onTap: logic.editEmail,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildItemGroupView({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Column(children: children),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    String? url,
    bool isAvatar = false,
    bool showRightArrow = true,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: showRightArrow ? onTap : null,
        child: SizedBox(
          height: 46.h,
          child: Row(
            children: [
              label.toText..style = Styles.ts_0C1C33_14sp,
              const Spacer(),
              if (isAvatar)
                AvatarView(
                  width: 32.w,
                  height: 32.h,
                  url: url,
                  text: value,
                  textStyle: Styles.ts_FFFFFF_10sp,
                )
              else
                Expanded(
                    flex: 3,
                    child: (IMUtils.emptyStrToNull(value) ?? '').toText
                      ..style = Styles.ts_0C1C33_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis
                      ..textAlign = TextAlign.right),
              if (showRightArrow)
                ImageRes.rightArrow.toImage
                  ..width = 20.w
                  ..height = 20.h,
            ],
          ),
        ),
      );
}
