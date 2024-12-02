/*
 * @File     : epg.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:28
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道节目单
 */

import 'package:iptv/core/entities/channel/channel.dart';
import 'package:iptv/core/entities/epg/epg_programme.dart';
import 'package:iptv/core/entities/epg/epg_programme_recent.dart';

import 'epg_programme_list.dart';

class Epg{
  // 频道名称
  String? channel;

  // 节目列表
  EpgProgrammeList? programmeList;

  Epg({String? channel,EpgProgrammeList? programmeList}){
    this.channel = channel ?? "";
    this.programmeList = programmeList ?? EpgProgrammeList();
  }

  EpgProgrammeRecent recentProgramme() {
    var currentTime = DateTime.now().millisecond;
    return EpgProgrammeRecent();
  }

  Epg example(Channel channel){
    return Epg(
      channel: channel.epgName,
      programmeList: EpgProgrammeList(
      )
    );
  }


  Epg empty(Channel channel){
    return Epg(
      channel: channel.epgName,
      programmeList: EpgProgrammeList(
        value:[EpgProgramme(title: "暂无节目")],
      )
    );
  }
}