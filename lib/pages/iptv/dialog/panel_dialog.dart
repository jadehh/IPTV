import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:iptv/pages/iptv/dialog/controller/panel_dialog_controller.dart';
import 'package:iptv/pages/iptv/index.dart';



class PanelDialog extends GetView<PanelDialogController> {
  final bool isSettingView;
  const PanelDialog({this.isSettingView=false,super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: PanelDialogController(),
        builder: (controller)=>Stack(
      children: [
        isSettingView ? _buildTopLeft(context):Container(),
        _buildTopRight(context),
        _buildBottom(),
      ].delayed(enable: DebugSettings.delayRender),
    ));
  }
  Widget _buildTopLeft(BuildContext context) {
    return  Positioned( top: 20.w,left: 20.w,child: SizedBox(height: 80.w,child: Text("默认直播源",style: TextStyle(fontSize: 60.sp,color: Theme.of(context).colorScheme.onSurface))));
  }

  // 右上角
  Widget _buildTopRight(BuildContext context) {
    return Positioned(
      top: 20.h,
      right: 20.w,
      child: Row(
        children: [
          PanelIptvChannel(controller.iptvController.currentIptv.value.channel
              .toString()
              .padLeft(2, '0')),
          Container(
            padding: const EdgeInsets.fromLTRB(4, 0, 12, 0).r,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 12, 0).r,
                  child: SizedBox(
                    height: 50.w,
                    child: VerticalDivider(
                      thickness: 2.w,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const PanelTime(),
              ],
            )
          )
          // 分隔符
        ],
      ),
    );
  }

  // 底部
  Positioned _buildBottom() {
    return Positioned(
      bottom: 0,
      left: 80.w,
      right: 0,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelIptvInfo(),
            SizedBox(height: 10.h),
            isSettingView ? const SettingView():Container(),
            isSettingView ? Container():Column(children: [
              SizedBox(height: 5.h),
              const PanelPlayerInfo(),
              SizedBox(height: 5.h),
              const PanelIptvList()
            ]),
          ].delayed(enable: DebugSettings.delayRender),
        )
    );
  }
}
