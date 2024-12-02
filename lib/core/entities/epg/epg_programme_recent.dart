/*
 * @File     : epg_programme_recent.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:43
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 当前正在播放
 */

import 'epg_programme.dart';

class EpgProgrammeRecent{
  /// 当前正在播放
  EpgProgramme? now;

  /// 稍后播放
  EpgProgramme? next;

  EpgProgrammeRecent({this.now,this.next});
}


// }