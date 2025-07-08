// Flutterの基本的なデザイン部品を使うためのおまじない
import 'package:flutter/material.dart';

// さっき作った2つの画面ファイルをここで読み込んでおくの
import 'screens/chat_screen.dart';
import 'screens/self_check_screen.dart';

// このアプリの始まりはここからよ、という合図
void main() {
  runApp(const MyApp());
}

// アプリ全体の大枠を定義するわ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'メンタルケアアプリ',
      // アプリの見た目のテーマカラー。優しい緑色にしてみたわ♪
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // アプリの最初の「家」となる部分を指定するの
      home: const MyHomePage(),
    );
  }
}

// ここがナビゲーションを持つメイン画面の本体よ
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 画面の状態を管理する部分。どの画面が選ばれているか、などを記憶するの
class _MyHomePageState extends State<MyHomePage> {
  // 今、何番目のタブが選ばれているかを記憶する変数
  int _selectedIndex = 0;

  // ナビゲーションバーで切り替える画面のリスト
  // ここに、さっき作った画面の「設計図」を入れておくのよ
  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(), // 0番目: チャット画面
    SelfCheckScreen(), // 1番目: セルフチェック画面
  ];

  // タブがタップされた時に呼ばれる関数
  void _onItemTapped(int index) {
    // setStateは「画面を再描画して！」という魔法の呪文
    setState(() {
      _selectedIndex = index; // 記憶している番号を、タップされたものに更新
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffoldは画面の基本的な骨格よ。これがないと始まらないわ
    return Scaffold(
      appBar: AppBar(
        // 画面上部のタイトルバー
        title: const Text('あなたの心を軽くするアプリ'),
      ),
      // 画面のメインコンテンツ部分。選ばれているタブに応じて表示が変わるの
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // そして、これが画面下のナビゲーションバー本体よ
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'AIチャット',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'セルフチェック',
          ),
        ],
        currentIndex: _selectedIndex, // 今どのタブが光るかを指定
        onTap: _onItemTapped, // タップされた時の処理を指定
      ),
    );
  }
}
