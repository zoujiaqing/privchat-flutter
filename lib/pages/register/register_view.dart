import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/register_page_bg.dart';
import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StrRes.newUserRegister.toText
              ..style = Styles.ts_0C1C33_20sp_semibold,
            30.verticalSpace,
            Obx(() => InputBox.phone(
                  label: StrRes.phoneNumber,
                  hintText: StrRes.plsEnterPhoneNumber,
                  code: logic.areaCode.value,
                  onAreaCode: logic.openCountryCodePicker,
                  controller: logic.phoneCtrl,
                )),
            // 16.verticalSpace,
            // InputBox.invitationCode(
            //   label: StrRes.invitationCode,
            //   hintText: sprintf(StrRes.plsEnterInvitationCode, [
            //     logic.needInvitationCodeRegister ? '' : '（${StrRes.optional}）'
            //   ]),
            //   controller: logic.invitationCodeCtrl,
            // ),
            30.verticalSpace,
            Obx(() => Button(
                  text: StrRes.nextStep,
                  enabled: logic.enabled.value,
                  onTap: logic.next,
                )),
          ],
        ),
      );
}
