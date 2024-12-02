import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/pages/iptv/page/iptv_view.dart';
import 'package:media_kit/media_kit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:iptv/common/index.dart';


void main() async {
  print(await getApplicationSupportDirectory());


  MediaKit.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();



  // 强制横屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  // 小白条、导航栏沉浸
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  // 保持屏幕常亮
  WakelockPlus.enable();
  // 初始化
  await PrefsUtil.init();
  LoggerUtil.init();
  RequestUtil.init();

  // 注册全局Controller
  Get.put(PlayController());
  Get.put(IptvController());
  Get.put(UpdateController());

  runApp(const MyApp());


}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.dark(surface: Colors.black);

    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      child: RestartWidget(
        child: GetMaterialApp(
          title: '我的电视',
          theme: ThemeData(
            colorScheme: colorScheme,
          ),
          scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
          localizationsDelegates: const [...GlobalMaterialLocalizations.delegates, GlobalWidgetsLocalizations.delegate],
          supportedLocales: const [Locale("zh", "CH"), Locale("en", "US")],
          home: const DelayRenderer(
            child: DoubleBackExit(
              child: IptvPage(),
            ),
          ),
          builder: (BuildContext context, Widget? widget) {
            return OKToast(
              position: const ToastPosition(align: Alignment.topCenter, offset: 0),
              textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              dismissOtherOnShow: true,
              child: widget!,
            );
          },
        ),
      ),
    );
  }
}
