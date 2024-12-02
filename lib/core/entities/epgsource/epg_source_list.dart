/*
 * @File     : iptv_source_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:09
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 节目单来源列表
 */
import 'epg_source.dart';

class EpgSourceList{
  List<EpgSource>? value;
  EpgSourceList( {List<EpgSource>?  value}){
    this.value = value ?? [];
  }
}