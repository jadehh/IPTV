import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptv/common/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/pages/iptv/controller/iptv_page_controller.dart';
import 'package:iptv/pages/iptv/view/play_view.dart';
import 'package:iptv/pages/iptv/index.dart';
import 'package:media_kit_video/media_kit_video.dart';


class IptvPage extends GetView<IptvPageController> {
  static IptvController get iptvController => Get.find<IptvController>();

  const IptvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IptvPageController(),
        builder: (controller) {
          return Scaffold(
            body: _buildGestureListener(
              context,
              child: Container(
                  color: Colors.transparent,
                  child: Obx(() {
                    if (controller.loadingState.value == LoadingState.loading) {
                      return Stack(
                        children: [_buildLoading(context)],
                      );
                    } else if (controller.loadingState.value ==
                        LoadingState.failed) {
                      return Stack(
                        children: [_buildLoadFailed(context)],
                      );
                    } else {
                      return Stack(children: [
                        _buildPlayer(),
                        _buildIptvInfo(context),
                        _buildKeyboardListener(context),
                        _buildChannelSelect(),
                      ]);
                    }
                  })),
            ),
          );
        });
  }

  // 加载中界面
  Widget _buildLoading(BuildContext context) {
    return Positioned(
        left: 100.w,
        bottom: 20.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "加载中",
                  style: TextStyle(
                      fontSize: 40.sp,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                Padding(padding: EdgeInsets.only(left: 10.h)),
                SizedBox(
                  width: 20.h,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3.h,
                  ),
                )
              ],
            ),
            Visibility(
                visible: controller.loadingProgress.value.isNotEmpty,
                child: Text(controller.loadingProgress.value,
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha((255 * 0.5).toInt()))))
          ],
        ));
  }

  Widget _buildLoadFailed(BuildContext context) {
    return Positioned(
        left: 100.w,
        bottom: 20.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '加载失败',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.sp),
                ),
              ],
            ),
            Text(controller.loadingMsg.value,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 30.sp))
          ],
        ));
  }

  // 播放器主界面
  Widget _buildPlayer() {
    return Stack(children: [
      Video(
          controller: controller.playController.controller,
          fit: BoxFit.fill,
          controls: (state) {
            return playView(state);
          }),
      Obx(
        () => Visibility(
          visible: controller.playController.state.value == PlayerState.failed,
          child: Center(
            child: Text(
              controller.playController.msg.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.sp, color: Colors.red),
            ),
          ),
        ),
      ),
    ]);
  }


  /// 当前直播源信息
  Widget _buildIptvInfo(BuildContext context) {
    return Obx(
      () => iptvController.iptvInfoVisible.value
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
            left: 80.w,
            right: 0,
            child:  const PanelIptvInfo(epgShowFull: false),
          ),
        ],
      )
          : Container(),
    );
  }

  /// 键盘事件监听
  Widget _buildKeyboardListener(BuildContext context) {
    return EasyKeyboardListener(
      autofocus: true,
      focusNode: controller.focusNode,
      onKeyTap: {
        // 频道切换
        LogicalKeyboardKey.arrowUp: () {
          if (IptvSettings.channelChangeFlip) {
            controller.playNext();
          } else {
            controller.playPrev();
          }
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            controller.playPrev();
          } else {
            controller.playNext();
          }
        },
        // LogicalKeyboardKey.arrowLeft: ()=> iptvStore.currentIptv.value = iptvStore.getPrevGroupIptv(),
        // LogicalKeyboardKey.arrowRight: ()=> iptvStore.currentIptv.value = iptvStore.getNextGroupIptv(),

        // 打开面板
        LogicalKeyboardKey.select: () => controller.openPanelView(context),

        // 打开设置
        LogicalKeyboardKey.settings: () => controller.openSettingView(context),
        LogicalKeyboardKey.contextMenu: () =>
            controller.openSettingView(context),
        LogicalKeyboardKey.help: () => controller.openSettingView(context),

        // 数字选台
        LogicalKeyboardKey.digit0: () =>
            controller.iptvController.inputChannelNo('0'),
        LogicalKeyboardKey.digit1: () =>
            controller.iptvController.inputChannelNo('1'),
        LogicalKeyboardKey.digit2: () =>
            controller.iptvController.inputChannelNo('2'),
        LogicalKeyboardKey.digit3: () =>
            controller.iptvController.inputChannelNo('3'),
        LogicalKeyboardKey.digit4: () =>
            controller.iptvController.inputChannelNo('4'),
        LogicalKeyboardKey.digit5: () =>
            controller.iptvController.inputChannelNo('5'),
        LogicalKeyboardKey.digit6: () =>
            controller.iptvController.inputChannelNo('6'),
        LogicalKeyboardKey.digit7: () =>
            controller.iptvController.inputChannelNo('7'),
        LogicalKeyboardKey.digit8: () =>
            controller.iptvController.inputChannelNo('8'),
        LogicalKeyboardKey.digit9: () =>
            controller.iptvController.inputChannelNo('9'),
      },
      onKeyLongTap: {
        LogicalKeyboardKey.select: () => controller.openSettingView(context),
      },
      onKeyRepeat: {
        // 频道切换
        LogicalKeyboardKey.arrowUp: () {
          if (IptvSettings.channelChangeFlip) {
            controller.iptvController.currentIptv.value =
                controller.iptvController.getNextIptv();
          } else {
            controller.iptvController.currentIptv.value =
                controller.iptvController.getPrevIptv();
          }
        },
        LogicalKeyboardKey.arrowDown: () {
          if (IptvSettings.channelChangeFlip) {
            controller.iptvController.currentIptv.value =
                controller.iptvController.getPrevIptv();
          } else {
            controller.iptvController.currentIptv.value =
                controller.iptvController.getNextIptv();
          }
        },
      },
      child: Container(),
    );
  }

  /// 手势事件监听
  Widget _buildGestureListener(BuildContext context, {required Widget child}) {
    return SwipeGestureDetector(
      onSwipeUp: () {
        // 上滑
        controller.playNext();
      },
      onSwipeDown: () {
        // 下滑
        controller.playPrev();
      },
      // onDragLeft: () => iptvStore.currentIptv = iptvStore.getPrevGroupIptv(),
      // onDragRight: () => iptvStore.currentIptv = iptvStore.getNextGroupIptv(),
      child: GestureDetector(
        onTap: () {
          controller.focusNode.requestFocus();
          controller.openPanelView(context);
        },
        onDoubleTap: () => controller.openSettingView(context),
        onLongPress: () => controller.openSettingView(context),
        child: child,
      ),
    );
  }

  /// 数字选台
  Widget _buildChannelSelect() {
    return Positioned(
      top: 20.h,
      right: 20.w,
      child: Obx(
        () => PanelIptvChannel(controller.iptvController.channelNo.value),
      ),
    );
  }
}
