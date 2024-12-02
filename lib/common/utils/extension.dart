/*
 * @File     : extension.dart
 * @Author   : jade
 * @Date     : 2024/10/14 14:02
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
class Extension{
  static bool isIpV6(String url){
    var urlPattern = RegExp("^((http|https)://)?(\\[[0-9a-fA-F:]+])(:[0-9]+)?(/.*)?\$");
    return urlPattern.hasMatch(url);
  }
}