import 'dart:async';

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
              child: Center(
                child: _showAudioWave
                    ? Container(
                  height: 200.cale,
                  width: 360.cale,
                  decoration: BoxDecoration(
                    color: widget.recordAudioState.recordingState == 1
                        ? Color(0x8FED6D)
                        : Colors.red,
                    borderRadius: BorderRadius.circular(30.cale),
                  ),
                  child: Center(
                    child: Container(
                      height: 200.cale,
                      width: 200.cale,
                      child: Lottie.asset(
                          'assets/animation/record_auido.json'),
                    ),
                  ),
                )
                    : Container(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.cale),
              child: Text(
                widget.recordAudioState.noticeMessage,
                // style: AppTextStyle.textStyle_30_F7F7F7,
              ),
            ),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(250.cale),
                    topRight: Radius.circular(250.cale),
                  ),
                ),
                // color: Colors.grey,
                width: double.infinity,
                height: _height,
                child: Icon(
                  Icons.multitrack_audio,
                  color: Color(0x7E7E7E7E),
                  size: 60.cale,
                ),
              ),
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