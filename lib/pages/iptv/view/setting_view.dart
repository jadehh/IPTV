/*
 * @File     : setting_view.dart
 * @Author   : jade
 * @Date     : 2024/10/17 10:45
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:iptv/pages/iptv/controller/setting_view_controller.dart';

class SettingView extends GetView<SettingViewController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder(
        init: SettingViewController(),
        builder: (controller) => SizedBox(
              height: 80.w,
              child: TwoDimensionListView(
                size: (rowHeight: 70.w, colWidth: 0),
                scrollOffset: (row: 0, col: -1),
                gap: (row: 20.h, col: 20.w),
                itemCount: (
                  row: 1,
                  col: (row) => controller.settingItemList.length,
                ),
                onSelect: (position) {
                  controller.settingItemList[position.col].onTap();
                },
                itemBuilder: (context, position, isSelected) {
                  return _buildSettingItem(
                      controller.settingItemList[position.col],
                      isSelected,
                      context);
                },
              ),
            ));
  }

  Widget _buildSettingItem(
      SettingItem item, bool isSelected, BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w).r,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.onSurface.withAlpha(112),
        borderRadius: BorderRadius.circular(15).r,
      ),
      child: Center(
        child: Text(
          item.title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 32.sp,
          ),
        ),
      ),
    );
  }
}
