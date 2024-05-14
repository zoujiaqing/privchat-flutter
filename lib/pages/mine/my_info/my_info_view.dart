import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import '../../../core/controller/im_controller.dart';
import 'my_info_logic.dart';
import 'package:privchat/widgets/group_item_view.dart';

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
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.avatar,
                      isAvatar: true,
                      value: imLogic.userInfo.value.nickname,
                      url: imLogic.userInfo.value.faceURL,
                      onTap: logic.openPhotoSheet,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.name,
                      value: imLogic.userInfo.value.nickname,
                      onTap: logic.editMyName,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.gender,
                      value: imLogic.userInfo.value.isMale ? StrRes.man : StrRes.woman,
                      onTap: logic.selectGender,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
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
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.mobile,
                      value: imLogic.userInfo.value.phoneNumber,
                      showRightArrow: false,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
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
}
