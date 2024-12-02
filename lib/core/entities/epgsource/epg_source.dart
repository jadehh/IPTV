/*
 * @File     : iptv_source.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:07
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 节目单来源
 */
class EpgSource {
  // 名称
  String? name;

  /// 链接
  String? url;

  EpgSource({String? name,String? url}){
    this.name = name ?? "";
    this.url = url ?? "";
  }
}
