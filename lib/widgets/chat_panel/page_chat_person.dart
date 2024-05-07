import 'package:flutter/material.dart';
import 'package:privchat/utils/int_ext.dart';
import 'package:privchat/widgets/chat_panel/AppWidget.dart';
import 'package:provider/provider.dart';

import 'provider_chat_content.dart';
import 'chat_bottom.dart';
import 'chat_element_self.dart';

class PageChatPerson extends StatefulWidget {

  @override
  State<PageChatPerson> createState() => _PageChatPersonState();
}

class _PageChatPersonState extends State<PageChatPerson> {
  /// 1 文本
  /// 2 图片
  /// 3 语音
  /// 4 视频
  /// 5 提示消息
  /// 6 提示消息
  final List<Map> _arrayChatMessage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // for (int i = 13; i >= 0; i--) {
    //   //_arrayChatMessage.addAll(_cache);
    //   print("------------------i % 6 + 1:${i % 6 + 1}");
    //   _arrayChatMessage.add({
    //     'id': i,
    //     'type': i % 6 + 1,
    //     'content_1': '你吃饭了吗2${i}-${i % 6}',
    //     'content_2': {
    //       'picture_mini': {
    //         'url':
    //             'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
    //         'width': 450,
    //         'height': 200
    //       },
    //       'picture':
    //           'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
    //     },
    //     'content_3':
    //         'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
    //     'content_4': '',
    //     'content_5': '',
    //     'content_6': '',
    //     'times': 1000000 + i
    //   });
    // }

    _arrayChatMessage.add({
      'id': 99,
      'type': 1,
      'content_1': '你吃饭了吗? ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://img2.baidu.com/it/u=3202947311,1179654885&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 1,
      'content_1': '我吃过了你呢？ ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://img2.baidu.com/it/u=3202947311,1179654885&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://img2.baidu.com/it/u=3202947311,1179654885&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://lmg.jj20.com/up/allimg/1114/033021091503/210330091503-6-1200.jpg',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://lmg.jj20.com/up/allimg/1114/033021091503/210330091503-6-1200.jpg',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202107%2F16%2F20210716215819_76234.thumb.1000_0.png&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1679722694&t=6ddea52a86e658f1a73f6e0e3865bad6',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url':
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202107%2F16%2F20210716215819_76234.thumb.1000_0.png&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1679722694&t=6ddea52a86e658f1a73f6e0e3865bad6',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url': 'https://photo.tuchong.com/4274381/f/1139873881.jpg',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });
    _arrayChatMessage.add({
      'id': 100,
      'type': 2,
      'content_1': ' ',
      'content_2': {
        'picture_mini': {
          'url': 'https://photo.tuchong.com/4274381/f/11398738812.jpg',
          'width': 800,
          'height': 500
        },
        'picture':
        'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      },
      'content_3':
      'https://user-info-1302720239.cos.ap-nanjing.myqcloud.com/userIcon/user_icon_000100.jpg',
      'content_4': '',
      'content_5': '',
      'content_6': '',
      'times': 1000000 + 9
    });

    //print('--datum:${widget.userInfoOther}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xffEDEDED),
        shadowColor: Color(0xffdddddd),
        elevation: 1.cale,
        leading: AppWidget.iconBack(() {
          // AppNavigator().navigateBack();
        }),
        centerTitle: true,
        title: Text("sadasdasd",
          style: TextStyle( color: Color(0xFF000000)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.cale),
            child: AppWidget.inkWellEffectNone(
              onTap: () {},
              child: Icon(
                Icons.dark_mode,
                size: 46.cale,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: ChangeNotifierProvider<ProviderChatContent>(
        create: (BuildContext context) => ProviderChatContent(),
        child: Consumer(builder: (BuildContext context,
            ProviderChatContent providerChatContent, child) {
          return Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  Expanded(
                    child: AppWidget.inkWellEffectNone(
                      onTap: () {
                        FocusScope.of(context).requestFocus(
                          FocusNode(),
                        );
                        context
                            .read<ProviderChatContent>()
                            .updateContentShow(false);
                      },
                      child: Container(color: Colors.amber,)
                      // child: ListView.builder(
                      //   padding: EdgeInsets.symmetric(vertical: 30.cale),
                      //   physics: const BouncingScrollPhysics(
                      //     parent: AlwaysScrollableScrollPhysics(),
                      //   ),
                      //   shrinkWrap: false,
                      //   reverse: _arrayChatMessage.length > 7,
                      //   itemCount: _arrayChatMessage.length,
                      //   // itemExtent: 188.cale,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     if (index % 2 != 0) {
                      //       return ChatElementSelf(
                      //         userInfo: widget.userInfoOther,
                      //         chatMessage: _arrayChatMessage[index],
                      //       );
                      //     } else {
                      //       return ChatElementOther(
                      //           userInfo: widget.userInfoOther,
                      //           chatMessage: _arrayChatMessage[index]);
                      //     }
                      //   },
                      // ),
                    ),
                  ),
                  ChatBottom(
                    providerChatContent: providerChatContent,
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}