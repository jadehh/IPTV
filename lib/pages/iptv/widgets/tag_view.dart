/*
 * @File     : tag_view.dart
 * @Author   : jade
 * @Date     : 2024/10/17 16:38
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TagView extends StatelessWidget {
  final String text;
  const TagView( this.text,{super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10).r,
          color: Colors.red
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 32.sp,
        ),
      ));
  }
}