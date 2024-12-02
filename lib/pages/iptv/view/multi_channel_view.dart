/*
 * @File     : multi_channel_view.dart.dart
 * @Author   : jade
 * @Date     : 2024/10/17 15:15
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';


class MultiChannelView extends GetView{
  const MultiChannelView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(top: 10.h,right: 50.w,bottom: 10.h),
        width: 680.w,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(120)
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(padding: EdgeInsets.only(left: 100.w,top: 10.h),child:  Text("多线路",style: TextStyle(fontSize: 60.sp)),), Expanded(child: MultiChannelListView() )
            ],
          ),
        ),),
    );
  }
}