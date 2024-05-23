import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

import 'personal_info_logic.dart';

class PersonalInfoPage extends StatelessWidget {
  final logic = Get.find<PersonalInfoLogic>();

  PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.personalInfo,
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
                      value: logic.nickname,
                      url: logic.faceURL,
                      isFirstItem: true,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.name,
                      value: logic.nickname,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.gender,
                      value: logic.isMale ? StrRes.man : StrRes.woman,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.birthDay,
                      value: logic.birth,
                      isLastItem: true,
                    ),
                  ],
                ),
                10.verticalSpace,
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.mobile,
                      value: logic.phoneNumber,
                      onTap: logic.clickPhoneNumber,
                      isFirstItem: true,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.email,
                      value: logic.email,
                      onTap: logic.clickEmail,
                      isLastItem: true,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
