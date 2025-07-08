// 必要な部品たちをインポートするわよ
import 'package:flutter/material.dart';

// まずは、チャットメッセージのデータを保持するための、小さな「設計図」クラスを作るの。
// これがあると、コードがすごく整理されて綺麗になるわ。
class ChatMessage {
  final String text; // メッセージの本文
  final bool isUserMessage; // これがユーザーのメッセージか、AIのメッセージか

  ChatMessage({required this.text, required this.isUserMessage});
}

// ユーザーの操作で見た目が変わるから、今回も「StatefulWidget」を使いましょうね
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 文字入力ボックスを操作するためのコントローラー。魔法の杖みたいなものよ
  final TextEditingController _textController = TextEditingController();

  // チャットの会話履歴を記憶しておくためのリスト。
  // 最初は、見た目を確認するためのダミーメッセージを入れておくわね。
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'なんだか、疲れちゃった…', isUserMessage: true),
    ChatMessage(text: 'そうだったのですね。お話、聞かせていただけますか？', isUserMessage: false),
    ChatMessage(text: 'SNSを見てたら、なんだか焦っちゃって。', isUserMessage: true),
    ChatMessage(text: '他の人の輝きが、時に自分を不安にさせることもありますよね。焦らなくても大丈夫ですよ。', isUserMessage: false),
  ];

  // メッセージを送信したときの処理（今はまだガワだけ）
  void _handleSubmitted(String text) {
    _textController.clear(); // 送信したら入力ボックスを空にする
    
    // setStateで画面を更新！
    setState(() {
      // 新しいメッセージを会話履歴の「一番上」に追加するの
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true));
    });
  }

  // ここからは画面の「見た目」を作っていくわよ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Columnで、チャット表示エリアと入力エリアを縦に並べるの
      body: Column(
        children: [
          // Expandedで、残りのスペースを全部チャット表示エリアにする
          Expanded(
            // ListView.builderで、メッセージのリストを画面に描画する
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, // これがミソ！リストを逆順にして、新しいメッセージが下に来るようにするの
              itemCount: _messages.length, // 表示するメッセージの数
              itemBuilder: (context, index) {
                final message = _messages[index];
                // メッセージ一つ一つの「ふきだし」のデザインは、別の部品に任せるとスッキリするわ
                return _MessageBubble(
                  text: message.text,
                  isUserMessage: message.isUserMessage,
                );
              },
            ),
          ),
          // ここが画面下の、メッセージ入力エリアよ
          _buildTextComposer(),
        ],
      ),
    );
  }

  // メッセージ入力エリアの見た目を作る関数
  Widget _buildTextComposer() {
    return Container(
      // 少し影をつけて、周りと区別しやすくするの
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 1,
            color: Colors.black12,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Rowで、入力ボックスと送信ボタンを横に並べるわ
      child: Row(
        children: [
          // Expandedで、入力ボックスができるだけ幅を取るようにする
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'メッセージを入力…',
              ),
              // エンターキーが押されたときも送信できるように
              onSubmitted: _handleSubmitted,
            ),
          ),
          // 送信ボタン
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}

// チャットの「ふきだし」のデザインを担当する、小さな部品
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const _MessageBubble({required this.text, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    // Rowでふきだしを左右どちらかに寄せるの
    return Row(
      // ユーザーのメッセージなら右寄せ、AIなら左寄せ
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // ふきだしのデザイン
          decoration: BoxDecoration(
            // 色も、ユーザーかAIかで変えてあげる
            color: isUserMessage ? Colors.green[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          // 文字がコンテナのフチにくっつきすぎないように余白を
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          // 横幅が広がりすぎないように制限をかける
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(text),
        ),
      ],
    );
  }
}
