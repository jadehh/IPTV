/*
 * @File     : channel.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:19
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道
 */
class Channel {
  /// 频道名称
  String? name;

  /// 节目单名称，用于查询节目单
  String? epgName;

  /// 播放地址
  List<String>? urlList;

  /// 台标
  String? logo;

  Channel({String? name, String? epgName, List<String>? urlList, this.logo}) {
    this.name = name ?? "";
    this.epgName = epgName ?? "";
    this.urlList = urlList ?? [];
  }
}

