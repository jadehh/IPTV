/*
 * @File     : event.dart
 * @Author   : jade
 * @Date     : 2024/10/10 13:34
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'dart:async';
import 'package:iptv/common/index.dart';



/// 全局事件
class EventBus {
  static EventBus? _instance;

  final _logger = LoggerUtil.create(['播放器']);


  static EventBus get instance {
    _instance ??= EventBus();
    return _instance!;
  }

  final Map<String, StreamController> _streams = {};

  /// 触发事件
  void emit<T>(String name, T data) {
    if (!_streams.containsKey(name)) {
      _streams.addAll({name: StreamController.broadcast()});
    }
    _logger.debug("Emit Event：$name\r\n$data");

    _streams[name]!.add(data);
  }

  /// 监听事件
  StreamSubscription<dynamic> listen(String name, Function(dynamic)? onData) {
    if (!_streams.containsKey(name)) {
      _streams.addAll({name: StreamController.broadcast()});
    }
    return _streams[name]!.stream.listen(onData);
  }
}