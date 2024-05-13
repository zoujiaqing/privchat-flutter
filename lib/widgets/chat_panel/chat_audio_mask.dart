import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:privchat/utils/int_ext.dart';

import 'provider_chat_content.dart';

class ChatAudioMask extends StatefulWidget {
  final RecordAudioState recordAudioState;
  const ChatAudioMask({Key? key, required this.recordAudioState})
      : super(key: key);

  @override
  State<ChatAudioMask> createState() => _ChatAudioMaskState();
}

class _ChatAudioMaskState extends State<ChatAudioMask> {
  double _height = 0;
  bool _showAudioWave = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 150)).then((value) {
      if (mounted) {
        setState(() {
          _height = 200.cale;
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 350)).then((value) {
      if (mounted) {
        setState(() {
          _showAudioWave = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // 这将子组件对齐到列的末尾
                children: <Widget>[
                  _showAudioWave
                      ? Container(
                          height: 100.cale,
                          width: 180.cale,
                          decoration: BoxDecoration(
                            // color: widget.recordAudioState.recordingState == 1
                            //     ? Color(0x8FED6D)
                            //     : Colors.green,
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.cale),
                          ),
                          child: Container(
                            height: 100.cale,
                            width: 100.cale,
                            child: Lottie.asset(
                              'assets/animation/record_auido.json',
                            ),
                          ),
                        )
                      : Container(), // 如果 _showAudioWave 为 false，则显示空的 Container
                ],
              ),
            ),
            Container(
                height: 100.cale,
                margin: EdgeInsets.symmetric(horizontal: 10.cale),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // 关闭按钮，使用 Container 包裹并添加圆形灰色背景
                      Container(
                        padding: EdgeInsets.all(8.0), // 根据需要调整内边距
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 设置形状为圆形
                          color: Colors.grey, // 设置背景颜色为灰色
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // 可以在这里实现关闭应用或返回上一个页面的逻辑
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.cale),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          widget.recordAudioState.noticeMessage,
                          // style: AppTextStyle.textStyle_30_F7F7F7,
                          style: TextStyle(fontSize: 20), // 使用您需要的文本样式
                        ),
                      ),
                      // 文 按钮
                      Container(
                        padding: EdgeInsets.all(8.0), // 根据需要调整内边距
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // 设置形状为圆形
                          color: Colors.grey, // 设置背景颜色为灰色
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent), // 背景色透明
                            elevation:
                                MaterialStateProperty.all<double>(0), // 阴影为0
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent), // 点击时的覆盖色透明
                          ),
                          child: Text(
                            '文',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white60),
                          ),
                          onPressed: () {
                            // 可以在这里实现关闭应用或返回上一个页面的逻辑
                          },
                        ),
                      ),
                    ])),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 10.cale),
            //   child: Text(
            //     widget.recordAudioState.noticeMessage,
            //     // style: AppTextStyle.textStyle_30_F7F7F7,
            //   ),
            // ),
            Center(
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.cale),
                      topRight: Radius.circular(100.cale),
                    ),
                  ),
                  // color: Colors.grey,
                  width: double.infinity,
                  height: _height / 2,
                  child: Transform.rotate(
                    angle: 90 * pi / 180,
                    child: Icon(
                      Icons.wifi,
                      color: Color(0x7E7E7E7E),
                      size: 30.cale,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
