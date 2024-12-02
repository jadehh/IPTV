/*
 * @File     : iptv_source.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:07
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 直播源
 */
class IptvSource {
  // 名称
  String? name;

  /// 链接
  String? url;

  /// 是否本地
  bool? isLocal;

  IptvSource({String? name, String? url, bool? isLocal}) {
    this.name = name ?? "";
    this.url = url ?? "";
    this.isLocal = isLocal ?? false;
  }
}
