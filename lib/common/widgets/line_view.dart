/*
 * @File     : line_view.dart
 * @Author   : jade
 * @Date     : 2024/10/18 10:32
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:iptv/pages/iptv/index.dart';

class LineView extends GetView{
  final String lineTitle;
  final String tagText;
  final String url;
  const LineView(this.lineTitle,this.tagText,this.url,{super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(30).r,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30).r,
              color: Theme.of(context).colorScheme.onSurface
          ),
          child:Padding(padding: EdgeInsets.only(left: 40.w,top: 3.h,bottom: 3.h),child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex: 7,child:
              Column(
                children: [
                  Row(
                    children: [
                      Text(lineTitle,style: TextStyle(color: Theme.of(context).colorScheme.surface,fontSize: 50.sp),),
                      SizedBox(width: 20.w,),
                      TagView(tagText),
                      SizedBox(width: 10.w,),
                      TagView(Extension.isIpV6(url) ?  " IPV6 ":" IPV4 "),
                    ],
                  ),
                  Text(maxLines: 1,url,style: TextStyle(color: Theme.of(context).colorScheme.surface,fontSize: 24.sp),overflow: TextOverflow.ellipsis),
                ],
              ),),

              Flexible(flex: 3, child:  Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // 圆形装饰
                    border: Border.all(color: Colors.lightBlueAccent, width: 2.r), // 圆的边框
                  ),
                  child: const Center(child: CircleAvatar(radius: 3,),)), // 圆内的子Widget
              )
            ],
          ),
          )
      ),
    );
  }

}