// Flutterの基本的な部品と、状態を管理するための部品を読み込むわ
import 'package:flutter/material.dart';

// 「StatefulWidget」は、チェックボックスのようにユーザーの操作で見た目が変わる画面で使うの
class SelfCheckScreen extends StatefulWidget {
  const SelfCheckScreen({super.key});

  @override
  // ここで画面の状態を管理する相棒を呼び出すのよ
  State<SelfCheckScreen> createState() => _SelfCheckScreenState();
}

// こちらが画面の状態を管理する、縁の下の力持ち「State」クラスよ
class _SelfCheckScreenState extends State<SelfCheckScreen> {
  // ステップ1で考えた質問をリストとして用意しておくわ
  final List<String> _questions = [
    'SNSを開くと、時間の感覚がなくなることがある？',
    '他人の投稿を見て、自分と比べて落ち込むことがある？',
    '寝る直前や起きてすぐにSNSをチェックしてしまう？',
    '「いいね」の数やコメントが気になって何度も確認してしまう？',
    'SNSを見ていないと、何か見逃しているような不安を感じる？',
  ];

  // 各質問の答え（チェックされたか否か）を記憶しておくためのリスト
  // 最初は全部チェックされていない(false)から、質問の数だけfalseを用意するの
  late List<bool> _answers;

  // この画面が作られた最初の瞬間に一度だけ呼ばれる特別な関数
  @override
  void initState() {
    super.initState();
    // ここで回答リストを初期化しているのよ
    _answers = List<bool>.filled(_questions.length, false);
  }

  // 診断結果をポップアップで表示するための関数
  void _showResultDialog() {
    // チェックされた（true）回答の数を数えるわ
    final int yesCount = _answers.where((answer) => answer == true).length;
    String resultMessage;

    // 「はい」の数に応じてメッセージを決めるロジック
    if (yesCount <= 1) {
      resultMessage = '素晴らしい！SNSと健全な関係を築けていますね♪';
    } else if (yesCount <= 3) {
      resultMessage = '少しお疲れ気味かもしれません。時にはスマホを置いて、深呼吸してみませんか？';
    } else {
      resultMessage = '心がお疲れのサインかも。このアプリで少し休みましょう。デジタルデトックスもおすすめです。';
    }

    // ポップアップ（ダイアログ）を表示する魔法
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('診断結果'),
          content: Text(resultMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop(); // ポップアップを閉じる
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Paddingで画面の左右に少し余白を作って、見た目を整えるわ
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column( // Columnは、部品を上から下に縦に並べるための箱よ
        children: [
          // Expandedを使うと、残りのスペースを全部使ってくれるの
          Expanded(
            // ListView.builderは、リスト形式のデータを表示するのに最適な部品
            child: ListView.builder(
              itemCount: _questions.length, // リストの項目数（質問の数）
              itemBuilder: (context, index) {
                // CheckboxListTileは、テキストとチェックボックスがセットになった便利な部品
                return CheckboxListTile(
                  title: Text(_questions[index]), // 質問文を表示
                  value: _answers[index], // この質問の現在の回答（チェック状態）
                  onChanged: (bool? value) {
                    // チェック状態が変わった時に呼ばれる関数
                    setState(() { // 見た目を更新するおまじない
                      _answers[index] = value!; // 新しい回答を記憶
                    });
                  },
                );
              },
            ),
          ),
          // SizedBoxで、リストとボタンの間に少しスペースを空けるの
          const SizedBox(height: 20),
          // ElevatedButtonは、立体感のある押しやすいボタンよ
          ElevatedButton(
            onPressed: _showResultDialog, // ボタンが押されたら診断結果を表示する
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50), // ボタンの高さを指定
            ),
            child: const Text('診断する'),
          ),
        ],
      ),
    );
  }
}
