/*
 * @File     : multi_channel_list_view.dart
 * @Author   : jade
 * @Date     : 2024/10/18 10:31
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:iptv/common/widgets/line_view.dart';


class MultiChannelListView extends GetView{
  static IptvController iptvController = Get.find<IptvController>();
  final multiLineList = [iptvController.currentIptv.value.urlList.first,"https://www.111111111"];
  MultiChannelListView({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: multiLineList.length,
        itemBuilder: (context,index){
          return LineView("线路1", "回放", multiLineList[index]);
        });
  }

}
