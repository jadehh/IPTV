# IPTV

## 使用

### 操作方式

遥控器操作方式主流电视直播软件一致；

- 频道切换：使用上下方向键，或者数字键切换频道；屏幕上下滑动；
- 频道选择：OK键；单击屏幕；
- 设置页面：菜单、帮助键、长按OK键；双击屏幕；

### 自定义设置

1. 进入设置页面
2. 请求网址：`http://<设备IP>:10381`
3. 按界面提示操作

支持修改直播源、节目单、缓存时间等

直播源：不支持多源，多源会存在频道重复问题

## 下载
可以通过右侧release进行下载或拉取代码到本地进行编译

## 说明
- **网络环境必须支持IPV6**（默认源）

## 功能

- [x] 换台反转
- [x] 数字选台
- [x] 节目单
- [x] 开机自启
- [x] 自动更新
- [x] 自定义直播源
- [x] 自定义节目单
- [x] 性能优化
- [x] 多平台支持

## 更新日志

[更新日志](./CHANGELOG.md)

## 开发环境

```
[√] Flutter (Channel stable, 3.19.4, on Microsoft Windows [版本 10.0.19045.3448], locale zh-CN)
[√] Windows Version (Installed version of Windows is version 10 or higher)
[√] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[√] Visual Studio - develop Windows apps (Visual Studio 生成工具 2022 17.7.5)
[√] Android Studio (version 2023.2)
[√] VS Code, 64-bit edition (version 1.87.2)
```

## 声明

此项目（IPTV）是个人为了兴趣而开发, 仅用于学习和测试。 所用API皆从官方网站收集, 不提供任何破解内容。

## 致谢

- [my-tv](https://github.com/lizongying/my-tv)
- [参考设计稿](https://github.com/lizongying/my-tv/issues/594)
- [IPV6直播源](https://github.com/zhumeng11/IPTV)
- [live](https://github.com/fanmingming/live)
- [pilipala](https://github.com/guozhigq/pilipala)
- 等等