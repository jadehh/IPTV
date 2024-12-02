/*
 * @File     : channel_group_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:25
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道分组
 */
import 'channel_list.dart';

class ChannelGroup{
  /// 分组名称
  String? name ;

  /// 频道列表
  ChannelList? channelList;

  ChannelGroup({String? name,ChannelList? channelList}){
    this.name = name ?? "";
    this.channelList = channelList ?? ChannelList();
  }
}
