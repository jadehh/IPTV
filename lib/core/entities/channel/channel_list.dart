/*
 * @File     : channel_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:21
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道列表
 */

import 'channel.dart';

class ChannelList{
  ///频道列表
  List<Channel>? value;

  ChannelList({List<Channel>? value}){
    this.value = value ?? [];
  }
}