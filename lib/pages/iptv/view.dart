import 'dart:async';
import 'dart:ffi';
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



class IptvPage extends StatefulWidget {
  const IptvPage({super.key});

  @override
  State<IptvPage> createState() => _IptvPageState();
}

class _IptvPageState extends State<IptvPage> {
  static PlayerStore get playerStore => Get.find<PlayerStore>();
  static IptvStore get iptvStore => Get.find<IptvStore>();
  static UpdateStore get updateStore => Get.find<UpdateStore>();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> traverseIptv(Iptv iptv) async{
    final debounce = Debounce(duration: const Duration(milliseconds: 100));
    iptvStore.iptvInfoVisible.value = true;
    debounce.debounce(() async {
        IptvSettings.initialIptvIdx = iptvStore.iptvList.indexOf(iptv);
        await playerStore.playIptv(iptvStore.currentIptv);
        Timer(const Duration(seconds: 1), () {
          if (iptv == iptvStore.currentIptv) {
            iptvStore.iptvInfoVisible.value = false;
          }
        });
      });
  }



  Future<void> _initData() async {
    await playerStore.init();
    await iptvStore.refreshIptvList();
    await iptvStore.refreshEpgList();
    iptvStore.currentIptv = iptvStore.iptvList.elementAtOrNull(IptvSettings.initialIptvIdx) ?? iptvStore.iptvList.first;
    await traverseIptv(iptvStore.currentIptv);
    updateStore.refreshLatestRelease();
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
    return Video(
      controller: playerStore.controller,fit:BoxFit.fill,
      controls: (state) {
      return playerControls(state);
    },);
  }

  /// 当前直播源信息
  Widget _buildIptvInfo() {
    return Obx( () => iptvStore.iptvInfoVisible.value
          ? Stack(
              children: [
                // 频道号
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: PanelIptvChannel(iptvStore.currentIptv.channel.toString().padLeft(2, '0')),
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
                            color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20).r,
                          ),
                          child: PanelIptvInfo(epgShowFull: false),
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
            iptvStore.currentIptv = iptvStore.getNextIptv();
          } else {
            iptvStore.currentIptv = iptvStore.getPrevIptv();
          }
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            iptvStore.currentIptv = iptvStore.getPrevIptv();
          } else {
            iptvStore.currentIptv = iptvStore.getNextIptv();
          }
        },
        // LogicalKeyboardKey.arrowLeft: ()=> iptvStore.currentIptv = iptvStore.getPrevGroupIptv(),
        // LogicalKeyboardKey.arrowRight: ()=> iptvStore.currentIptv = iptvStore.getNextGroupIptv(),

        // 打开面板
        LogicalKeyboardKey.select: () => _openPanel(),

        // 打开设置
        LogicalKeyboardKey.settings: () => _openSettings(),
        LogicalKeyboardKey.contextMenu: () => _openSettings(),
        LogicalKeyboardKey.help: () => _openSettings(),

        // 数字选台
        LogicalKeyboardKey.digit0: () => iptvStore.inputChannelNo('0'),
        LogicalKeyboardKey.digit1: () => iptvStore.inputChannelNo('1'),
        LogicalKeyboardKey.digit2: () => iptvStore.inputChannelNo('2'),
        LogicalKeyboardKey.digit3: () => iptvStore.inputChannelNo('3'),
        LogicalKeyboardKey.digit4: () => iptvStore.inputChannelNo('4'),
        LogicalKeyboardKey.digit5: () => iptvStore.inputChannelNo('5'),
        LogicalKeyboardKey.digit6: () => iptvStore.inputChannelNo('6'),
        LogicalKeyboardKey.digit7: () => iptvStore.inputChannelNo('7'),
        LogicalKeyboardKey.digit8: () => iptvStore.inputChannelNo('8'),
        LogicalKeyboardKey.digit9: () => iptvStore.inputChannelNo('9'),
      },
      onKeyLongTap: {
        LogicalKeyboardKey.select: () => _openSettings(),
      },
      onKeyRepeat: {
        // 频道切换
        LogicalKeyboardKey.arrowUp: () {
          if (IptvSettings.channelChangeFlip) {
            iptvStore.currentIptv = iptvStore.getNextIptv();
          } else {
            iptvStore.currentIptv = iptvStore.getPrevIptv();
          }
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            iptvStore.currentIptv = iptvStore.getPrevIptv();
          } else {
            iptvStore.currentIptv = iptvStore.getNextIptv();
          }
        },
      },
      child: Container(),
    );
  }

  /// 手势事件监听
  Widget _buildGestureListener({required Widget child}) {
    return SwipeGestureDetector(
      onSwipeUp: () => iptvStore.currentIptv = iptvStore.getNextIptv(),
      onSwipeDown: () => iptvStore.currentIptv = iptvStore.getPrevIptv(),
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
      child: Obx(() => PanelIptvChannel(iptvStore.channelNo.value),
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
