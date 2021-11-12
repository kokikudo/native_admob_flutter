import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

import 'screens/native_ads.dart';
import 'screens/full_screen_ads.dart';
import 'screens/banner_ads.dart';

void main() async {
  // プラグインをネイティブ側でアクセスできるようにする
  WidgetsFlutterBinding.ensureInitialized();

  // MobileAdsSDK　初期化
  await MobileAds.initialize();
  // テストする端末のデバイスID
  MobileAds.setTestDeviceIds(['9345804C1E5B8F0871DFE29CA0758842']);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Ads Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bannerController 初期化
  final bannerController = BannerAdController();

  // bannerの高さ
  // double _bannerAdHeight = 0;

  @override
  void initState() {
    super.initState();
    // Stateの初期化時にリスナーを定義
    bannerController.onEvent.listen((e) {
      // Map型のデータが返ってくる
      // キーの初めがイベントの種類らしい（詳しく書いてない）
      final event = e.keys.first;
      // final info = e.values.first;
      switch (event) {
        case BannerAdEvent.loaded:
          //おそらくロード完了時にバナーのデフォルトの高さが取得できるので変数に入れてる
          // setState(() => _bannerAdHeight = (info as int)?.toDouble());
          break;
        default:
          break;
      }
    });
    // コントローラーのロード
    bannerController.load();
  }

  // Widgetが破棄されたらコントローラーも破棄する
  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // タブコントローラー。TabBarViewと同じ長さ。
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text('Ads demo'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: Text('Native Ads')),
                    body: NativeAds(),
                  ),
                ));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              // 各Tabに割り当てるView
              // タブを変えると、この部分だけ切り替わる
              child: TabBarView(
                children: [NativeAds(), BannerAds(), FullScreenAds()],
              ),
            ),

            // バナー広告。コントローラーを渡す。
            // サイズの指定がなければデフォルトのサイズになる
            // デフォルトなので背景が黒くなる場合があるので、嫌なら背景を透明にする
            BannerAd(controller: bannerController),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.blue,
          child: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Native Ads'),
              Tab(text: 'Banner Ads'),
              Tab(text: 'Full Screen Ads'),
            ],
          ),
        ),
      ),
    );
  }
}
