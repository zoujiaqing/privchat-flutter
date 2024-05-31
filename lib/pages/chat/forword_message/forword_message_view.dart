import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'forword_message_logic.dart';

class ForwordMessagePage extends StatelessWidget {
  final logic = Get.find<ForwordMessageLogic>();

  ForwordMessagePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // 获取传递过来的消息ID

              logic.forwardMessage(logic.forwordMsg, logic.selectedContacts);
              Get.back();
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
              itemCount: logic.friendList.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  var contact = logic.friendList[index];
                  bool isSelected = logic.selectedContacts.contains(contact.userID!);
                  return ListTile(
                    title: Text(contact.nickname!),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value == true) {
                          logic.selectedContacts.add(contact.userID!);
                        } else {
                          logic.selectedContacts.remove(contact.userID!);
                        }
                      },
                    ),
                  );
                });
              },
            ),
      ),

    );
  }
}
