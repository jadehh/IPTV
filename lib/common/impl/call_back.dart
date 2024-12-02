/*
 * @File     : call_back.dart
 * @Author   : jade
 * @Date     : 2024/10/15 14:51
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
abstract class CallBack{
  final Function retry;
  final String name;
  CallBack(this.retry,this.name);
}