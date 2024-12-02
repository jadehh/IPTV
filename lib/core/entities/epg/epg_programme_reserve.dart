/*
 * @File     : epg_programme_reserve.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:00
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 节目预约
 */
class EpgProgrammeReserve{
  /// 频道名称
  String? channel;

  /// 节目名称
  String? programme;

  /// 开始时间
  double? startAt;

  /// 结束时间
  double? endAt;

  EpgProgrammeReserve({String? channel,String? programme,double? startAt,double? endAt}){
    this.channel = channel ?? "";
    this.programme = programme ?? "";
    this.startAt = startAt ?? 0;
    this.endAt = endAt ?? 0;
  }
}
