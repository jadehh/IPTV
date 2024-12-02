import 'package:flutter/material.dart';
import 'package:iptv/common/event/index.dart';

/// 路由工具
class NavigatorUtil {
  NavigatorUtil._();

  /// 覆盖弹出
  static Future<void> push(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 透明渐变
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0.0, end: 1.0).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
            ),
            child: child,
          );
        },
        pageBuilder: (context, _, __) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            body: SafeArea(
              child: GestureDetector(
                onTap: () async{
                  // 恢复
                  Navigator.pop(context);
                  RefreshEvent.showIptv();
                },
                child: Container(
                  color: Colors.transparent,
                  child: page,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
