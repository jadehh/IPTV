/*
 * @File     : epg_programme.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:31
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道节目
 */

class EpgProgramme{
  /// 开始时间（时间戳）
  double? startAt;

  /// 结束时间（时间戳）
  double? endAt;

  /// 节目名称
  String? title;

  EpgProgramme({double? startAt,double? endAt,String? title}){
    this.startAt = startAt ?? 0;
    this.endAt = endAt ?? 0;
    this.title = title ?? "";
  }
}