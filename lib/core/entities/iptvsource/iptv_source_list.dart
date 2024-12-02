/*
 * @File     : iptv_source_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:09
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 直播源列表
 */
import 'iptv_source.dart';

class IptvSourceList{
  List<IptvSource>? value;
  IptvSourceList( {List<IptvSource>?  value}){
    this.value = value ?? [];
  }
}