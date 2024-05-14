import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

import 'system_setup_logic.dart';

class SystemSetupPage extends StatelessWidget {
  final logic = Get.find<SystemSetupLogic>();

  SystemSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.systemSetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            GroupItemView(
              children: [
                ItemView(
                  label: StrRes.languageSetup,
                  showRightArrow: true,
                  isFirstItem: true,
                  isLastItem: true,
                  onTap: ()=> logic.setLanguage()
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
