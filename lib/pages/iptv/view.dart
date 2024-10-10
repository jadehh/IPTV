import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv/common/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/pages/iptv/controller/play_controller.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv/pages/panel/view.dart';
import 'package:iptv/pages/panel/widgets/iptv_ch.dart';
import 'package:iptv/pages/panel/widgets/iptv_info.dart';
import 'package:iptv/pages/settings/view.dart';

import 'package:iptv/common/event/event.dart';
import 'package:iptv/common/event/refresh_event.dart';



class IptvPage extends StatefulWidget {
  const IptvPage({super.key});

  @override
  State<IptvPage> createState() => _IptvPageState();
}

class _IptvPageState extends State<IptvPage> {
  static PlayController get playController => Get.find<PlayController>();
  static IptvController get iptvController => Get.find<IptvController>();
  static UpdateController get updateController => Get.find<UpdateController>();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    EventBus.instance.listen(
      RefreshEvent.kRefresh,
          (index) async {
        switch (index) {
          case RefreshType.vod:
            await traverseIptv(iptvController.currentIptv.value);
            await iptvController.refreshEpgList();
        }
      },
    );
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> traverseIptv(Iptv iptv) async{
    final debounce = Debounce(duration: const Duration(milliseconds: 100));
    iptvController.iptvInfoVisible.value = true;
    debounce.debounce(() async {
        IptvSettings.initialIptvIdx = iptvController.iptvList.indexOf(iptv);
        await playController.playIptv(iptvController.currentIptv.value);
        // 节目单显示时间
        Timer(const Duration(seconds: 5), () {
          if (iptv == iptvController.currentIptv.value) {
            iptvController.iptvInfoVisible.value = false;
          }
        });
      });
  }



  Future<void> _initData() async {
    await iptvController.refreshIptvList();
    await iptvController.refreshEpgList();
    iptvController.currentIptv.value = iptvController.iptvList.elementAtOrNull(IptvSettings.initialIptvIdx) ?? iptvController.iptvList.first;
    await traverseIptv(iptvController.currentIptv.value);
    updateController.refreshLatestRelease();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildGestureListener(
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              _buildPlayer(),
              _buildIptvInfo(),
              _buildKeyboardListener(),
              _buildChannelSelect(),
            ],
          ),
        ),
      ),
    );
  }

  /// 播放器主界面
  Widget _buildPlayer() {
    return Stack(children: [
      Video(
      controller: playController.controller,fit:BoxFit.fill,
      controls: (state) {
        return playerControls(state);
      }),
      Obx(() => Visibility(
          visible: playController.state.value == PlayerState.failed,
          child:  Center(
            child: Text(
              playController.msg.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.sp, color: Colors.red),
            ),
          ),
        ),
      ),

    ]);
  }

  /// 当前直播源信息
  Widget _buildIptvInfo() {
    return Obx( () => iptvController.iptvInfoVisible.value
          ? Stack(
              children: [
                // 频道号
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: PanelIptvChannel(iptvController.currentIptv.value.channel.toString().padLeft(2, '0')),
                ),
                // 频道信息
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20).r,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20).r,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20).r,
                          ),
                          child: const PanelIptvInfo(epgShowFull: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  /// 键盘事件监听
  Widget _buildKeyboardListener() {
    return EasyKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyTap: {
        // 频道切换
        LogicalKeyboardKey.arrowUp: () {
          if (IptvSettings.channelChangeFlip) {
            iptvController.currentIptv.value = iptvController.getNextIptv();
          } else {
            iptvController.currentIptv.value = iptvController.getPrevIptv();
          }
          RefreshEvent.refresh();
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            iptvController.currentIptv.value = iptvController.getPrevIptv();
          } else {
            iptvController.currentIptv.value = iptvController.getNextIptv();
          }
          RefreshEvent.refresh();
        },
        // LogicalKeyboardKey.arrowLeft: ()=> iptvStore.currentIptv.value = iptvStore.getPrevGroupIptv(),
        // LogicalKeyboardKey.arrowRight: ()=> iptvStore.currentIptv.value = iptvStore.getNextGroupIptv(),

        // 打开面板
        LogicalKeyboardKey.select: () => _openPanel(),

        // 打开设置
        LogicalKeyboardKey.settings: () => _openSettings(),
        LogicalKeyboardKey.contextMenu: () => _openSettings(),
        LogicalKeyboardKey.help: () => _openSettings(),

        // 数字选台
        LogicalKeyboardKey.digit0: () => iptvController.inputChannelNo('0'),
        LogicalKeyboardKey.digit1: () => iptvController.inputChannelNo('1'),
        LogicalKeyboardKey.digit2: () => iptvController.inputChannelNo('2'),
        LogicalKeyboardKey.digit3: () => iptvController.inputChannelNo('3'),
        LogicalKeyboardKey.digit4: () => iptvController.inputChannelNo('4'),
        LogicalKeyboardKey.digit5: () => iptvController.inputChannelNo('5'),
        LogicalKeyboardKey.digit6: () => iptvController.inputChannelNo('6'),
        LogicalKeyboardKey.digit7: () => iptvController.inputChannelNo('7'),
        LogicalKeyboardKey.digit8: () => iptvController.inputChannelNo('8'),
        LogicalKeyboardKey.digit9: () => iptvController.inputChannelNo('9'),
      },
      onKeyLongTap: {
        LogicalKeyboardKey.select: () => _openSettings(),
      },
      onKeyRepeat: {
        // 频道切换
        LogicalKeyboardKey.arrowUp: () {
          if (IptvSettings.channelChangeFlip) {
            iptvController.currentIptv.value = iptvController.getNextIptv();
          } else {
            iptvController.currentIptv.value  = iptvController.getPrevIptv();
          }
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            iptvController.currentIptv.value  = iptvController.getPrevIptv();
          } else {
            iptvController.currentIptv.value  = iptvController.getNextIptv();
          }
        },
      },
      child: Container(),
    );
  }

  /// 手势事件监听
  Widget _buildGestureListener({required Widget child}) {
    return SwipeGestureDetector(
      onSwipeUp: () => iptvController.currentIptv.value = iptvController.getNextIptv(),
      onSwipeDown: () => iptvController.currentIptv.value = iptvController.getPrevIptv(),
      // onDragLeft: () => iptvStore.currentIptv = iptvStore.getPrevGroupIptv(),
      // onDragRight: () => iptvStore.currentIptv = iptvStore.getNextGroupIptv(),
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
          _openPanel();
        },
        onDoubleTap: () => _openSettings(),
        child: child,
      ),
    );
  }

  /// 数字选台
  Widget _buildChannelSelect() {
    return Positioned(
      top: 20.h,
      right: 20.w,
      child: Obx(() => PanelIptvChannel(iptvController.channelNo.value),
      ),
    );
  }


  void _openPanel() {
    NavigatorUtil.push(context, const PanelPage());
  }

  void _openSettings() {
    NavigatorUtil.push(context, const SettingsPage());
  }
}
