import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_sample/entity.dart';
import 'package:future_provider_sample/repository.dart';

// FutureProvider 単一の値を非同期的に生成する
// FutureProvider = Provider + FutureBuilder とみなすことができます。
// 使用例としては、HTTPリクエストやファイルの読み取り、その他Futureを取り扱う処理全般で使用する。

void main() {
  runApp(
    ProviderScope(
      // FutureProviderのAsyncValueを上書きする
      // FutureProviderでデータを取得できているかの確認にも使える
      overrides: [
        // 上書きの内容
        listProvider.overrideWithValue(
          const AsyncValue.data([
            Entity(id: 1, title: 'First title'),
            Entity(id: 2, title: 'Second title'),
            Entity(id: 3, title: 'Third title'),
          ]),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Future Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// Repositoryを保持したrepositoryProviderインスタンスを生成
final repositoryProvider = Provider((ref) => Repository());

final listProvider = FutureProvider<List<Entity>>((ref) async {
  // Repositoryインスタンスを取得
  final repository = ref.read(repositoryProvider);
  // repository.fetchListメソッドの実行結果を返す
  return repository.fetchList();
});

// FutureProvider の便利なのが、↑この記述だけで AsyncValue のオブジェクトを生成してくれること
// AsyncValue は非同期通信の通信中、通信終了、異常終了処理をハンドリングしてくれる Riverpod の便利な機能のこと

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FutureProviderの監視
    final asyncValue = ref.read(listProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Future Provider')),
      body: Center(
        child: asyncValue.when(
          // dataに取得したいデータが格納されている
          data: (data) => data.isNotEmpty
              ? ListView(
                  children: data
                      .map(
                        (Entity entity) => Text(entity.title),
                      )
                      .toList(),
                )
              : const Text('Data is empty.'),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text(error.toString()),
        ),
      ),
    );
  }
}
